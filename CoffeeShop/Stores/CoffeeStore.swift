//
//  CoffeeStore.swift
//  CoffeeShop
//
//  Created by Henrik on 19/04/2026.
//
import SwiftUI

@MainActor @Observable
class CoffeeStore {
    private let orderService: OrderService
    private let pushNotficationService: PushNotificationService
    
    init(
        orderService: OrderService,
        pushNotificationService: PushNotificationService
    ) {
        self.orderService = orderService
        self.pushNotficationService = pushNotificationService
    }
    
    func buy(coffee: CoffeeType) async {
        do {
            try await pushNotficationService.startLiveActivity(coffee: coffee)
        }
        catch {
            print("Failed starting live activity: \(error as NSError)")
        }
        await orderService.order(coffee)
    }
    
    func joinEvent() async {
        
    }
}
