//
//  ContentView.swift
//  CoffeeShop
//
//  Created by Henrik on 18/04/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                CoffeeOrderView()
            }
            .navigationTitle("The Coffee Shop")
        }
        
    }
}

#Preview {
    ContentView()
        .onAppear() {
            UINavigationBar.setupAppearance()
        }
}
