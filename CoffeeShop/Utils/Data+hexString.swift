//
//  Data+hexString.swift
//  CoffeeShop
//
//  Created by Henrik on 19/04/2026.
//
import Foundation

extension Data {
    var hexString: String {
        self.map { String(format: "%02.2hhx", $0) }.joined()
    }
}
