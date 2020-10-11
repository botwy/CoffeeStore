//
//  ProductDetail.swift
//  iCoffeeWidget
//

import SwiftUI

struct ProductWidgetView: View {
    
    var product: ProductPromotion
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                Image(product.imageName)
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 180, height: 110)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                Text(product.name)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.bottom, 3)
            }
            VStack(spacing: 5) {
                Text("\(product.oldPrice, specifier: "%.2f") руб")
                    .font(.body)
                    .foregroundColor(.gray)
                    .strikethrough()
                Text("\(product.price, specifier: "%.2f") руб")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .padding(.bottom)
        }
    }
}
