//
//  OrderCoffeeAttributes.swift
//  CoffeeShop
//
//  Created by Henrik on 19/04/2026.
//
import ActivityKit
import Foundation


enum OrderState: Codable, Equatable, Hashable {
    case received, queuing(QueueData), brewing(BrewingData), complete(CompleteData)
}

struct QueueData: Codable, Equatable, Hashable {
    let number: Int // Number in line
}

struct BrewingData: Codable, Equatable, Hashable {
    
}

struct CompleteData: Codable, Equatable, Hashable {
    let completeDate: Date
    let pickedUp: Bool
}

struct OrderCoffeeAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var state: OrderState
        var estimatedReady: Date?
    }
    
    var coffee: CoffeeType
    var orderDate: Date
}

import Playgrounds
#Playground {
    let attributes = OrderCoffeeAttributes(coffee: .espresso, orderDate: .now)
    let state = OrderCoffeeAttributes.ContentState.init(
//        state: .received,
        state: .queuing(.init(number: 7)),
//        state: .brewing(.init()),
//        state: .complete(.init(completeDate: .now, pickedUp: false)),
//        state: .complete(.init(completeDate: .now.advanced(by: -3 * 60), pickedUp: true)),
        estimatedReady: .now.addingTimeInterval(60*4)
//        estimatedReady: nil
    )
     
    let stateString = String(data: try JSONEncoder().encode(state), encoding: .utf8)!

    
    let roundtrip = try! JSONDecoder().decode(
        OrderCoffeeAttributes.ContentState.self,
        from: stateString.data(using: .utf8)!)
    
    print(String(data: try JSONEncoder().encode(attributes), encoding: .utf8)!)
    print(stateString)
}
