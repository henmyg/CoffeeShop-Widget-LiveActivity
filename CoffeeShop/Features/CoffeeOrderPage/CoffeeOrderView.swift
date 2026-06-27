//
//  CoffeeOrderView.swift
//  CoffeeShop
//
//  Created by Henrik on 26/04/2026.
//

import SwiftUI

struct CoffeeOrderView: View {
    var body: some View {
        VStack {
            Spacer()
            VStack {
                HStack {
                    CoffeeButton(type: .americano)
                    CoffeeButton(type: .espresso)
                }
                
                HStack {
                    CoffeeButton(type: .latte)
                    CoffeeButton(type: .cappucino)
                }
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    CoffeeOrderView()
}
