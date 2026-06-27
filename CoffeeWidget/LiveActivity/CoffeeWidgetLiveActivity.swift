//
//  CoffeeWidgetLiveActivity.swift
//  CoffeeWidget
//
//  Created by Henrik on 19/04/2026.
//

import ActivityKit
import WidgetKit
import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

struct CoffeeWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: OrderCoffeeAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack(spacing: 8) {
                HStack {
                    HStack {
                        context.attributes.coffee.icon
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 13))
                            .frame(height: 26)
                        Text(context.attributes.coffee.title)
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    if let estimatedReady = context.state.estimatedReady {
                        ProgressView(
                            timerInterval: context.attributes.orderDate...estimatedReady,
                            countsDown: false
                        ) {
                            Text("Est. Delivery: ")
                                .font(.caption)
                        } currentValueLabel: {
                            Text(estimatedReady, style: .timer)
                                .multilineTextAlignment(.trailing)
                        }
                        .frame(maxWidth: 120)
                    }
                }

                let state = context.state.state
                VStack(spacing: 4) {
                    OrderProgressBar(currentStep: state.step)
                        .padding(.horizontal, 8)
                    Text(state.title)
                        .font(.caption)
                }
            }
            .padding()
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        context.attributes.coffee.icon
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 13))
                            .frame(height: 26)
                        
                        Text(context.attributes.coffee.title)
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                    }
                    .frame(maxWidth: .infinity)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    let hide = context.state.estimatedReady == nil
                    let estimatedReady = context.state.estimatedReady ?? .now
                    
                    ZStack(alignment: .top) {
                        ProgressView(
                            timerInterval: context.attributes.orderDate...estimatedReady,
                            countsDown: false) {
                                Text("Est. Delivery: ")
                                    .font(.caption)
                            } currentValueLabel: {
                                Text(estimatedReady, style: .timer)
                                    .multilineTextAlignment(.trailing)
                            }
                            .if(hide) { $0.hidden() }
                        
                        if case let .complete(completeData) = context.state.state {
                            VStack(alignment: .leading) {
                                if completeData.pickedUp {
                                    HStack {
                                        Text("Picked up")
                                            .font(.caption)
                                        Spacer()
                                    }
                                }
                                else {
                                    
                                    Text("Done")
                                        .font(.caption)
                                    Text("\(completeData.completeDate, style: .relative) ago")
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    let state = context.state.state
                    VStack {
                        OrderProgressBar(currentStep: state.step)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                        
                        Text(state.title)
                    }
                }
            } compactLeading: {
                Image(.miniAmericano)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 13))
                    .frame(height: 26)
            } compactTrailing: {
                context.state.state.icon
                    .resizable()
                    .scaledToFit()
                    .padding(4)
                    .frame(height: 26)
            } minimal: {
                Image(.miniAmericano)
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            .keylineTint(Color.red)
        }
    }
}

extension CoffeeType {
    var icon: Image {
        switch self {
        case .americano: Image(.miniAmericano)
        case .cappucino: Image(.miniCappucino)
        case .espresso: Image(.miniEspresso)
        case .latte: Image(.miniLatte)
        }
    }
}

extension OrderState {
    var icon: Image {
        switch self {
        case .received: return .init(systemName: "handbag")
        case .queuing: return .init(systemName: "person.2")
        case .brewing: return .init(systemName: "cup.and.heat.waves")
        case .complete: return .init(systemName: "checkmark")
        }
    }
    
    var step: Int {
        switch self {
        case .received: return 0
        case .queuing: return 1
        case .brewing: return 2
        case .complete: return 3
        }
    }
    
    var title: String {
        return switch self {
        case .received: "Order received"
        case .queuing(let queueData): "In queue as #\(queueData.number)"
        case .brewing: "Brewing"
        case .complete: "Coffee ready"
        }
    }

    static var allCases: [OrderState] {
        [
            .received,
            .queuing(QueueData(number: 0)),
            .brewing(BrewingData()),
            .complete(.init(completeDate: .now, pickedUp: false))
        ]
    }
}

// MARK: - Progress Bar

struct OrderProgressBar: View {
    let currentStep: Int

    private let steps = OrderState.allCases
    private let activeColor = Color.orange
    private let inactiveColor = Color(uiColor: .systemGray2)
    private let circleSize: CGFloat = 28
    

    var body: some View {
        GeometryReader { geo in
            let spacing = (geo.size.width - circleSize * CGFloat(steps.count)) / CGFloat(steps.count - 1)

            ZStack(alignment: .leading) {
                // Background line
                Capsule()
                    .fill(inactiveColor)
                    .frame(height: 2)
                    .frame(maxWidth: .infinity)

                // Active line — stretches between center of first and center of current circle
                let totalLineWidth = (circleSize + spacing) * CGFloat(currentStep)
                let activeLineWidth = max(0, totalLineWidth - circleSize / 2)

                Capsule()
                    .fill(activeColor)
                    .frame(width: activeLineWidth + circleSize / 2, height: 2)

                // Circles
                HStack(spacing: spacing) {
                    ForEach(Array(steps.enumerated()), id: \.offset) { index, state in
                        let isActive = index <= currentStep
                        ZStack {
                            Circle()
                                .fill(isActive ? activeColor : inactiveColor)
                                .frame(width: circleSize, height: circleSize)
                            state.icon
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(isActive ? .white : .white.opacity(0.6))
                                .padding(6)
                                .frame(width: circleSize, height: circleSize)
                        }
                    }
                }
            }
        }
        .frame(height: circleSize)
    }
}

// MARK: - Preview
extension OrderCoffeeAttributes {
    fileprivate static var preview: OrderCoffeeAttributes {
        OrderCoffeeAttributes(coffee: .americano, orderDate: .now.addingTimeInterval(-60))
    }
}

extension OrderCoffeeAttributes.ContentState {
    fileprivate static var previewOrderReceived: OrderCoffeeAttributes.ContentState { OrderCoffeeAttributes.ContentState.init(
//        state: .received,
//        state: .queuing(.init(number: 3)),
        state: .brewing(.init()),
//        state: .complete(.init(completeDate: .now, pickedUp: false)),
//        state: .complete(.init(completeDate: .now.addingTimeInterval(-3 * 60), pickedUp: true)),
        estimatedReady: Date.now.addingTimeInterval(5*60)
//        estimatedReady: nil
    )
    }
}

#Preview("Notification", as: .content, using: OrderCoffeeAttributes.preview) {
   CoffeeWidgetLiveActivity()
} contentStates: {
    OrderCoffeeAttributes.ContentState.previewOrderReceived
}
