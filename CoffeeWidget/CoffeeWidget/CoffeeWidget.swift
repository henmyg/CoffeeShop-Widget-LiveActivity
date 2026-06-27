//
//  CoffeeWidget.swift
//  CoffeeWidget
//
//  Created by Henrik on 19/04/2026.
//

import WidgetKit
import SwiftUI
import AppIntents

// MARK: Data model
struct CoffeeWidgetData: TimelineEntry {
    let date: Date
    let configuration: CoffeeWidgetConfigurationIntent
    var products: [CoffeeType] { configuration.coffees }
}

// MARK: Data provider
struct CoffeeWidgetDataProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> CoffeeWidgetData {
        CoffeeWidgetData(date: Date(), configuration: CoffeeWidgetConfigurationIntent())
    }

    func snapshot(for configuration: CoffeeWidgetConfigurationIntent, in context: Context) async -> CoffeeWidgetData {
        CoffeeWidgetData(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: CoffeeWidgetConfigurationIntent, in context: Context) async -> Timeline<CoffeeWidgetData> {
        return Timeline(entries: [CoffeeWidgetData(date: Date(), configuration: configuration)], policy: .never)
    }
}

// MARK: Widget configuration
struct CoffeeWidgetConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Coffee widget configuration" }
    static var description: IntentDescription { "Configure the widget to your personal likings" }

    @Parameter(title: "Local coffee shop", default: "Lyngby", optionsProvider: CoffeeShopProvider())
    var coffeeShop: String
    
    @Parameter(title: "Coffees", default: [CoffeeType.americano, .espresso, .latte, .cappucino])
    var coffees: [CoffeeType]
}

// MARK: Widget
struct CoffeeWidget: Widget {
    let kind: String = "CoffeeWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: CoffeeWidgetConfigurationIntent.self,
            provider: CoffeeWidgetDataProvider()
        ) { data in
            CoffeeWidgetView(data: data)
                .containerBackground(.fill, for: .widget)
        }
        .supportedFamilies([.systemSmall])
    }
}
