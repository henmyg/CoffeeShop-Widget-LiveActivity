//
//  PushNotificationService.swift
//  CoffeeShop
//
//  Created by Henrik on 19/04/2026.
//
import SwiftUI
import UserNotifications
import ActivityKit

protocol PushNotificationService: Actor {
    func start() async throws
    
    func startLiveActivity(coffee: CoffeeType) throws
}

extension Activity {
    static func monitorTokens() async {
        await withTaskGroup { group in
            group.addTask {
                for await token in Activity<OrderCoffeeAttributes>.pushToStartTokenUpdates {
                    print("StartToken: \(token.hexString)")
                }
            }
            
            group.addTask {
                for await activity in Activity<OrderCoffeeAttributes>.activityUpdates {
                    print("New Activity: \(activity.id)")
                    if let token = activity.pushToken {
                        print("E) UpdateToken for \(activity.id): \(token.hexString)")
                    }
                    for await token in activity.pushTokenUpdates {
                        print("N) UpdateToken for \(activity.id): \(token.hexString)")
                    }
                }
                
                print("Finished find new activityes")
            }
        }
        
        print("Finished monitoring")
    }
}

actor RealPushNotificationService: PushNotificationService {
    func start() async throws {
        let center = UNUserNotificationCenter.current()
        let result = try await center.requestAuthorization(options: .alert)
        if result {
            await UIApplication.shared.registerForRemoteNotifications()
        }
        
        monitorTokens()
    }
    
    private func monitorTokens() {
        Task {
            await Activity<OrderCoffeeAttributes>.monitorTokens()
        }
    }
    
    func startLiveActivity(coffee: CoffeeType) throws {
        let attributes = OrderCoffeeAttributes(coffee: coffee, orderDate: .now)
        let initialState = OrderCoffeeAttributes.ContentState(
            state: .received,
            estimatedReady: nil)
        let staleDate: Date? = nil
        let activity = try Activity.request(
            attributes: attributes,
            content: .init(state: initialState, staleDate: staleDate),
            pushType: .token)
        print("LiveActivity started: \(activity.id)")
    }
}

actor MockPushNotificationService: PushNotificationService {
    func start() async throws {
        print("[MOCK] Push notifications arctivated!")
    }
    
    func startLiveActivity(coffee: CoffeeType) {
        print("[MOCK] Started live activity")
    }
}
