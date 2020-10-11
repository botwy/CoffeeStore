//
//  Cart.swift
//  iCoffee
//

import Foundation
import CodableFirebase

struct Cart: Codable, Identifiable {
    var id: String
    var ownerId: String
    var items: [Product] = []
}
  
extension Cart {
    
    enum FirebaseKey: String {
        case ownerId
    }
    
    var total: Double {
        if items.count > 0 {
            return items.reduce(0) { $0 + $1.price }
        } else {
            return 0
        }
    }
    
    mutating func add(_ item: Product) {
        items.append(item)
    }
    
    mutating func remove(_ item: Product) {
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
        }
    }
    
    mutating func emptyCart() {
        items = []
    }
}
