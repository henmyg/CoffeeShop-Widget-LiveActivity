//
//  CoffeeShopApp.swift
//  CoffeeShop
//
//  Created by Henrik on 18/04/2026.
//

import SwiftUI

@main
struct CoffeeShopApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .bootstrapper()
                .setupDependencies()
                .task {
                    UINavigationBar.setupAppearance()
                }
        }
    }
}

extension UINavigationBar {
    static func setupAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .font: UIFont.chalk(size: 24)
        ]
        appearance.largeTitleTextAttributes = [
            .font: UIFont.chalk(size: 30)
        ]
        
        Self.appearance().standardAppearance = appearance
    }
}



import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        print("App launched and AppDelegate is active.")
        return true
    }
    
    // You can add other delegate methods here, like notification handling
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Push notification token: \(deviceToken.hexString)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        print("Failed registering for push notifcations: \(error as NSError)")
    }
}


