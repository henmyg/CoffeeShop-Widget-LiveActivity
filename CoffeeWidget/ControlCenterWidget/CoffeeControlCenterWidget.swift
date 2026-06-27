//
//  ControlCenterWidget.swift
//  CoffeeShop
//
//  Created by Henrik on 11/06/2026.
//
import WidgetKit
import SwiftUI
import AppIntents

struct CoffeeControlCenterWidget: ControlWidget {
    let kind: String = "CoffeeControlCenterWidget"

    var body: some ControlWidgetConfiguration {
        AppIntentControlConfiguration(
            kind: kind,
            intent: CoffeeControlWidgetConfigurationIntent.self
        ) { configuration in
            return ControlWidgetButton(action: OrderCoffeeIntent(coffee: configuration.coffee)) {
                Label("Order coffee", systemImage: "cup.and.heat.waves.fill")
            }
        }
    }
}

struct CoffeeControlWidgetConfigurationIntent: ControlConfigurationIntent {
    static var title: LocalizedStringResource { "Coffee widget configuration" }
    static var description: IntentDescription { "Configure the widget to your personal likings" }

    @Parameter(title: "Local coffee shop", default: "Lyngby", optionsProvider: CoffeeShopProvider())
    var coffeeShop: String
    
    @Parameter(title: "Coffee", default: CoffeeType.americano)
    var coffee: CoffeeType
}

struct CoffeeControlWidgetDataProvider: ControlValueProvider {
    
    var previewValue = CoffeeWidgetData(date: .now, configuration: CoffeeWidgetConfigurationIntent())
    
    func currentValue() async throws -> CoffeeWidgetData {
        CoffeeWidgetData(date: Date(), configuration: CoffeeWidgetConfigurationIntent())
    }
}
