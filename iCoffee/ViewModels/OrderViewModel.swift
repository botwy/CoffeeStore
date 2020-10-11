//
//  OrderViewModel.swift
//  iCoffee
//

import Foundation
import Firebase
import CodableFirebase

class OrderViewModel: ObservableObject {
    
    let userService = UserService()
    
    @Published var paymentTypes = ["Наличные", "Банковская карта"]
    
    @Published var paymentType = 0
   
    @Published var isShowPaymentAlert = false
    @Published var totalPrice: Double = 0
    
    private var cartProducts: [Product] = []
    
    func setup(cartProducts: [Product]?, cartTotal: Double?) {
        self.cartProducts = cartProducts ?? []
        self.totalPrice = cartTotal ?? 0
    }
    
    func createOrder() {
        guard let userId = userService.currentUserId, !cartProducts.isEmpty else {
            return
        }
        let order = Order(
            id: UUID().uuidString,
            customerId: userId,
            orderProducts: cartProducts,
            amount: totalPrice
        )
        let orderService = OrderService()
        orderService.saveToFirestore(order: order)
        isShowPaymentAlert.toggle()
        totalPrice = 0
    }
}
