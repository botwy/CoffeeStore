//
//  OrderService.swift
//  iCoffee
//

import Foundation
import CombineFirebase

final class OrderService {
    
    func saveToFirestore(order: Order) {
        _ = FirebaseReference(.Order).document(order.id).setData(from: order)
    }
}
