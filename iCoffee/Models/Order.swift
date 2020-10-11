//
//  Order.swift
//  iCoffee
//

import Foundation
import CodableFirebase

struct Order: Identifiable, Codable {
    var id: String
    var customerId: String
    var orderProducts: [Product] = []
    var amount: Double = 0
}
