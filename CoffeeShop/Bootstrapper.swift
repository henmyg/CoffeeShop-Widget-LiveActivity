//
//  BootstrapperViewModifier.swift
//  CoffeeShop
//
//  Created by Henrik on 19/04/2026.
//
import SwiftUI

struct BootstrapperViewModifier: ViewModifier {
    @Environment(\.pushNoticationService) var pushNotificationService
    @State private var isBootstrapping = true
    
    func body(content: Content) -> some View {
        if isBootstrapping {
            Text("Starting app...")
                .task {
                    defer { isBootstrapping = false }
                    try? await pushNotificationService.start()
                    UINavigationBar.setupAppearance()
                }
        }
        else {
            content
        }
    }
}

extension View {
    func bootstrapper() -> some View {
        self.modifier(BootstrapperViewModifier())
    }
}
