//
//  CoffeeShopProvider.swift
//  CoffeeShop
//
//  Created by Henrik on 11/06/2026.
//
import AppIntents

struct CoffeeShopProvider: DynamicOptionsProvider {
    func results() async throws -> [String] {
        try? await Task.sleep(for: .milliseconds(500)) // Pretend to read from internet
        return ["Copenhagen C", "Vesterbro", "Østerbro", "Frederiksberg", "Lyngby"]
    }
}
