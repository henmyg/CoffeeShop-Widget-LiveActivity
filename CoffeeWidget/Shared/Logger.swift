//
//  Logger.swift
//  CoffeeShop
//
//  Created by Henrik on 11/06/2026.
//
import OSLog

extension Logger {
    private static var subsystem = "LeCoffee"
    
    static let widget = Logger(subsystem: subsystem, category: "Widget")
    static let coffeeOrder = Logger(subsystem: subsystem, category: "CoffeeOrder")
}
