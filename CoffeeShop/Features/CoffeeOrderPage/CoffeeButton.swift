//
//  CoffeeButton.swift
//  CoffeeShop
//
//  Created by Henrik on 26/04/2026.
//

import SwiftUI

struct CoffeeButton: View {
    @Environment(\.coffeeStore) private var coffeeStore
    let type: CoffeeType
    
    var body: some View {
        Button {
            Task {
                await coffeeStore.buy(coffee: type)
            }
        } label: {
            Image(type.image)
                .resizable()
                .overlay(alignment: .bottom) {
                    Text(type.title)
                        .font(.chalk())
                        .foregroundStyle(.white)
                        .padding(2)
                }
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 4, x: 2, y: 4)
        }
    }
}

#Preview {
    CoffeeButton(type: .cappucino)
        .padding()
}
