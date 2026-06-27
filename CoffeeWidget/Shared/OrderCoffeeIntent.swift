//
//  OrderCoffeeIntent.swift
//  CoffeeShop
//
//  Created by Henrik on 11/06/2026.
//
import AppIntents
import OSLog

struct OrderCoffeeIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Order coffee"
    
    @Parameter(title: "Coffee", default: .americano)
    var coffee: CoffeeType
    
    init() { }
    
    init(coffee: CoffeeType) {
        self.coffee = coffee
    }
    
    func perform() async throws -> some IntentResult {
        Logger.coffeeOrder.info("Ordering a \(coffee.rawValue, privacy: .public)")
        try? await Task.sleep(for: .milliseconds(200))
        
        return .)
    }
    
    static var parameterSummary: some ParameterSummary {
        Summary("Order a \(\.$coffee)")
    }
}
