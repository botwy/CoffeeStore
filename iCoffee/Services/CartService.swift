//
//  CartServices.swift
//  iCoffee
//

import Foundation
import CombineFirebase

final class CartService {
    
    func firebaseCartListener(userId: String?, completion: @escaping (Cart?) -> Void) {
        guard let userId = userId else {
            return completion(nil)
        }
        let ownerKey = Cart.FirebaseKey.ownerId.rawValue
        FirebaseReference(.Cart).whereField(ownerKey, isEqualTo: userId).addSnapshotListener { (snapshot, error) in
            completion(snapshot?.decode().first)
        }
    }
    
    func saveCartToFirestore(cart: Cart) {
        _ = FirebaseReference(.Cart).document(cart.id).setData(from: cart)
    }
}
