//
//  CoffeeType.swift
//  CoffeeShop
//
//  Created by Henrik on 05/06/2026.
//
import SwiftUI
import AppIntents

enum CoffeeType: String, Codable {
    case americano, latte, cappucino, espresso
}

extension CoffeeType: AppEnum {
    static let typeDisplayRepresentation = TypeDisplayRepresentation(name: "Coffee type")
    
    static let caseDisplayRepresentations: Dictionary<Self, DisplayRepresentation> = [
        Self.americano: DisplayRepresentation(title: "Americano"),
        Self.espresso: DisplayRepresentation(title: "Espresso"),
        Self.latte: DisplayRepresentation(title: "Latte"),
        Self.cappucino: DisplayRepresentation(title: "Cappucino"),
    ]
}

extension CoffeeType {
    var title: String {
        switch self {
        case .americano: return "Americano"
        case .cappucino: return "Cappucino"
        case .espresso: return "Espresso"
        case .latte: return "Latte"
        }
    }
}

extension CoffeeType {
    var image: ImageResource {
        switch self {
        case .americano: return .americano
        case .cappucino: return .cappucino
        case .espresso: return .espresso
        case .latte: return .latte
        }
    }
}
