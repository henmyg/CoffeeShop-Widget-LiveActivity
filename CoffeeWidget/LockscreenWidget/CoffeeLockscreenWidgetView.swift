//
//  CoffeeWidgetView.swift
//  CoffeeShop
//
//  Created by Henrik on 05/06/2026.
//
import SwiftUI
import WidgetKit
import AppIntents

struct CoffeeLockscreenWidgetView : View {
    var data: CoffeeLockscreenWidgetDataProvider.Entry
    
    var body: some View {
        ZStack {
            HStack {
                coffeeButton(coffee: data.coffeeOne)
                
                if let coffeeTwo = data.coffeeTwo {
                    Rectangle().frame(width: 1).padding(.vertical, 8)
                    coffeeButton(coffee: coffeeTwo)
                }
            }
            Color.clear
        }
        .background(Capsule().stroke(lineWidth: 1))
    }
    
    @ViewBuilder
    private func coffeeButton(coffee: CoffeeType) -> some View {
        Button(intent: OrderCoffeeIntent(coffee: coffee)) {
            Image(coffee.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(8)
        }
        .buttonStyle(.plain)
    }
}

// MARK: Preview
fileprivate extension CoffeeWidgetConfigurationIntent {
    static var lyngby: CoffeeWidgetConfigurationIntent {
        let intent = CoffeeWidgetConfigurationIntent()
        intent.coffeeShop = "Lyngby"
        return intent
    }
    
    static var vesterbro: CoffeeWidgetConfigurationIntent {
        let intent = CoffeeWidgetConfigurationIntent()
        intent.coffeeShop = "Vesterbro"
        intent.coffees = [.americano, .cappucino, .latte]
        return intent
    }
    
    static var frederiksberg: CoffeeWidgetConfigurationIntent {
        let intent = CoffeeWidgetConfigurationIntent()
        intent.coffeeShop = "Frederiksberg"
        intent.coffees = [.espresso]
        return intent
    }
}

#Preview(as: .accessoryRectangular) {
    CoffeeLockscreenWidget()
} timeline: {
    CoffeeWidgetData(date: .now, configuration: .lyngby)
    CoffeeWidgetData(date: .now, configuration: .vesterbro)
    CoffeeWidgetData(date: .now, configuration: .frederiksberg)
}
