//
//  CartView.swift
//  iCoffee
//

import SwiftUI

struct CartView: View {
    
    @ObservedObject var cartVM = CartViewModel()
    
    private var cartItems: [Product] {
        cartVM.cart?.items ?? []
    }
    
    var body: some View {
        if cartVM.isLoading {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.gray))
                .scaleEffect(2, anchor: .center)
        } else {
            render(cart: cartVM.cart)
        }
    }
    
    func render(cart: Cart?) -> some View {
        Group {
            if let cart = cart, !cart.items.isEmpty {
                renderList()
            } else {
                Text("Корзина пустая")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }
        }
    }
    
    func renderList() -> some View {
        NavigationView {
            List {
                
                Section {
                    ForEach(cartItems) { product in
                        HStack {
                            Text(product.name)
                            Spacer()
                            Text("\(product.price.clean)")
                        }
                    }
                    .onDelete { indexSet in
                        removeItem(at: indexSet)
                    }
                }
                
                Section {
                    NavigationLink(destination: CheckoutView()) {
                        Text("Сделать заказ")
                    }
                }
            }
            .navigationTitle("Корзина")
            .listStyle(GroupedListStyle())
        }
    }
    
    private func removeItem(at offsets: IndexSet) {
        guard let offset = offsets.first else { return }
        cartVM.cart?.items.remove(at: offset)
        cartVM.saveCartToFirestore()
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
