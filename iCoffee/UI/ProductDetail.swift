//
//  ProductDetail.swift
//  iCoffee
//

import SwiftUI

struct ProductDetail: View {
    
    @State var isShowAlert = false
    
    @ObservedObject var authViewModel: AuthViewModel
    
    var product: Product
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            ZStack(alignment: .bottom) {
                
                Image(product.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Rectangle()
                    .frame(height: 80)
                    .foregroundColor(.black)
                    .opacity(0.35)
                    .blur(radius: 10)
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(product.name)
                            .foregroundColor(.white)
                            .font(.largeTitle)
                    }
                    .padding(.leading)
                    .padding(.bottom)
                    Spacer()
                }
            }
            .listRowInsets(EdgeInsets())
            
            Text(product.description)
                .foregroundColor(.primary)
                .font(.body)
                .lineLimit(10)
                .padding()
            
            HStack {
                Spacer()
                OrderButton(isShowAlert: $isShowAlert, isLogin: authViewModel.isLogin, product: product)
                Spacer()
            }
            .padding(.top, 50)
        }
        .edgesIgnoringSafeArea(.top)
        .alert(isPresented: $isShowAlert) {
            Alert(
                title: Text(authViewModel.isLogin ? "Товар добавлен в корзину!" : "Не добавлен! Выполните вход в корзину"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct OrderButton: View {
    
    @ObservedObject var cartVM = CartViewModel()
    
    @Binding var isShowAlert: Bool
    
    let isLogin: Bool
    
    var product: Product
    
    var body: some View {
        Button(action: {
            isShowAlert.toggle()
            if isLogin {
                cartVM.addToCart(product: product)
            }
        }) {
            Text("Добавить в корзину")
        }
        .frame(width: 200, height: 50)
        .font(.headline)
        .foregroundColor(.white)
        .background(Color.blue)
        .cornerRadius(10)
    }
}

struct ProductDetail_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetail(authViewModel: AuthViewModel(), product: productDataMock)
    }
}
