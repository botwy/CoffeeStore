//
//  CheckoutView.swift
//  iCoffee
//

import SwiftUI

struct CheckoutView: View {
    
    @ObservedObject var cartVM = CartViewModel()
    @ObservedObject var orderVM = OrderViewModel()
    
    var body: some View {
        Form {
          paymentSection
          totalSection
        }
        .navigationBarTitle(Text("Заказ"), displayMode: .inline)
        .alert(isPresented: $orderVM.isShowPaymentAlert) {
            Alert(title: Text("Заказ подтвержден"), message: Text("Спасибо!"), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            orderVM.setup(cartProducts: cartVM.cart?.items, cartTotal: cartVM.cart?.total)
        }
    }
    
    var paymentSection: some View {
        Section {
            Picker(selection: $orderVM.paymentType, label: Text("Как вы хотите оплатить?")) {
                ForEach(0..<orderVM.paymentTypes.count) {
                    Text(orderVM.paymentTypes[$0])
                }
            }
        }
    }
    
    var totalSection: some View {
        Section(header: Text("Всего \(orderVM.totalPrice, specifier: "%.2f") руб").font(.largeTitle)) {
            Button(action: {
                createOrder()
                emptyCart()
            }, label: {
                Text("Подтвердите заказ")
            }).disabled(cartVM.cart?.items.isEmpty ?? true)
        }
    }
    
    private func createOrder() {
        orderVM.createOrder()
    }
    
    private func emptyCart() {
        cartVM.emptyCart()
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView()
    }
}
