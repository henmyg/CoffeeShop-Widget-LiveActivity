//
//  CoffeeWidgetView.swift
//  CoffeeShop
//
//  Created by Henrik on 05/06/2026.
//
import SwiftUI
import WidgetKit
import AppIntents

struct CoffeeWidgetView : View {
    @Environment(\.widgetRenderingMode) private var widgetRenderingMode

    var data: CoffeeWidgetDataProvider.Entry
    
    var body: some View {
        if data.products.count >= 4 {
            VStack {
                HStack {
                    coffeeButton(0)
                    coffeeButton(1)
                }
                
                HStack {
                    coffeeButton(2)
                    coffeeButton(3)
                }
            }
        }
        else {
            HStack {
                coffeeButton(0)
                coffeeButton(1)
                coffeeButton(2)
            }
        }
    }
    
    @ViewBuilder
    private func coffeeButton(_ index: Int) -> some View {
        if let coffee = coffee(for: index) {
            Button(intent: OrderCoffeeIntent(coffee: coffee)) {
                
                if let manipulated = coffee.image
                    .asUIImage?
                    .transparency(renderingMode: widgetRenderingMode)
                {
                    Image(uiImage: manipulated)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .buttonStyle(.plain)
        }
    }
    
    private func coffee(for index: Int) -> CoffeeType? {
        index < data.products.count ? data.products[index] : nil
    }
}

// TODO: MOVE


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

#Preview(as: .systemSmall) {
    CoffeeWidget()
} timeline: {
    CoffeeWidgetData(date: .now, configuration: .lyngby)
    CoffeeWidgetData(date: .now, configuration: .vesterbro)
    CoffeeWidgetData(date: .now, configuration: .frederiksberg)
}
