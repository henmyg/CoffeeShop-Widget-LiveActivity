//
//  OrderService.swift
//  CoffeeShop
//
//  Created by Henrik on 19/04/2026.
//

protocol OrderService: Actor {
    func order(_ coffee: CoffeeType)
}

actor MockOrderService: OrderService {
    func order(_ coffee: CoffeeType) {
        print("/order/\(coffee)")
    }
}
