//
//  CoffeeStoreKey.swift
//  CoffeeShop
//
//  Created by Henrik on 19/04/2026.
//
import SwiftUI

extension EnvironmentValues {
    @Entry var pushNoticationService: PushNotificationService = MockPushNotificationService()
    
    // MARK: Store
    @MainActor private struct CoffeeStoreKey: EnvironmentKey {
        @MainActor static let defaultValue: CoffeeStore = CoffeeStore(
            orderService: MockOrderService(),
            pushNotificationService: MockPushNotificationService())
    }
    
    @MainActor var coffeeStore: CoffeeStore {
        get { self[CoffeeStoreKey.self] }
        set { self[CoffeeStoreKey.self] = newValue }
    }
}

extension View {
    func setupDependencies() -> some View {
        let orderService = MockOrderService()
        let pushNotificationService = RealPushNotificationService()
        return self
            .environment(\.pushNoticationService, pushNotificationService)
            .environment(\.coffeeStore, CoffeeStore(
                orderService: orderService,
                pushNotificationService: pushNotificationService))
    }
}
