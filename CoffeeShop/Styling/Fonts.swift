//
//  Fonts.swift
//  CoffeeShop
//
//  Created by Henrik on 26/04/2026.
//
import SwiftUI
import UIKit

extension Font {
    static func chalk(size: CGFloat = 24) -> Font {
        Font.custom("ChalkboardSE-Regular", size: size)
    }
}

extension UIFont {
    static func chalk(size: CGFloat = 24) -> UIFont {
        guard let font = UIFont(name: "ChalkboardSE-Regular", size: size) else {
            print("No font found")
            return .systemFont(ofSize: size)
        }
        return font
    }
}

#Preview {
    Text("Hello there my friend")
        .font(.chalk())
}
