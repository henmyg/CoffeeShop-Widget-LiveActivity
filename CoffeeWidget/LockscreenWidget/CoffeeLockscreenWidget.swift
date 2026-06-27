//
//  CoffeeLockscreenWidget.swift
//  CoffeeShop
//
//  Created by Henrik on 11/06/2026.
//
import WidgetKit
import SwiftUI
import AppIntents

// MARK: Data model
struct CoffeeLockscreenWidgetData: TimelineEntry {
    let date: Date
    let configuration: CoffeeLockscreenWidgetConfigurationIntent
    var coffeeOne: CoffeeType { configuration.coffeeOne }
    var coffeeTwo: CoffeeType? { configuration.coffeeTwo }
}

// MARK: Data provider
struct CoffeeLockscreenWidgetDataProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> CoffeeLockscreenWidgetData {
        CoffeeLockscreenWidgetData(date: Date(), configuration: CoffeeLockscreenWidgetConfigurationIntent())
    }

    func snapshot(for configuration: CoffeeLockscreenWidgetConfigurationIntent, in context: Context) async -> CoffeeLockscreenWidgetData {
        CoffeeLockscreenWidgetData(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: CoffeeLockscreenWidgetConfigurationIntent, in context: Context) async -> Timeline<CoffeeLockscreenWidgetData> {
        return Timeline(entries: [CoffeeLockscreenWidgetData(date: Date(), configuration: configuration)], policy: .never)
    }
}

// MARK: Widget configuration
struct CoffeeLockscreenWidgetConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Coffee widget configuration" }
    static var description: IntentDescription { "Configure the widget to your personal likings" }

    @Parameter(title: "Local coffee shop", default: "Lyngby", optionsProvider: CoffeeShopProvider())
    var coffeeShop: String
    
    @Parameter(title: "Coffee 1", default: CoffeeType.americano)
    var coffeeOne: CoffeeType
    
    @Parameter(title: "Coffee 2", default: nil)
    var coffeeTwo: CoffeeType?
}

// MARK: Widget
struct CoffeeLockscreenWidget: Widget {
    let kind: String = "CoffeeLockscreenWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: CoffeeLockscreenWidgetConfigurationIntent.self,
            provider: CoffeeLockscreenWidgetDataProvider()
        ) { data in
            CoffeeLockscreenWidgetView(data: data)
                .containerBackground(.fill, for: .widget)
        }
        .supportedFamilies([.accessoryRectangular])
    }
}
