//
//  CoffeeWidgetBundle.swift
//  CoffeeWidget
//
//  Created by Henrik on 19/04/2026.
//

import WidgetKit
import SwiftUI

@main
struct CoffeeWidgetBundle: WidgetBundle {
    var body: some Widget {
        CoffeeWidget()
        CoffeeLockscreenWidget()
        CoffeeControlCenterWidget()
        CoffeeWidgetLiveActivity()
    }
}
