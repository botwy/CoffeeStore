//
//  CartViewModel.swift
//  iCoffee
//

import Foundation
import Firebase
import CodableFirebase

class CartViewModel: ObservableObject {
    
    let userService = UserService()
    let cartService = CartService()
    
    @Published var cart: Cart?
    @Published var isLoading = false
    
    init() {
        activateFirebaseListener()
    }
    
    private func activateFirebaseListener() {
        isLoading = true
        cartService.firebaseCartListener(userId: userService.currentUserId) { cart in
            self.cart = cart
            self.isLoading = false
        }
    }
    
    func addToCart(product: Product) {
        if cart == nil, let userId = userService.currentUserId {
            cart = Cart(id: UUID().uuidString, ownerId: userId)
        }
        cart?.add(product)
        saveCartToFirestore()
    }
    
    func emptyCart() {
        cart?.emptyCart()
        saveCartToFirestore()
    }
    
    func saveCartToFirestore() {
        if let cart = cart {
            cartService.saveCartToFirestore(cart: cart)
        }
    }
}
