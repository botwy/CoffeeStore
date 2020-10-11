//
//  ProductItem.swift
//  iCoffee
//

import SwiftUI

struct ProductItem: View {
    
    var product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(product.imageName)
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 170)
                .cornerRadius(10)
                .shadow(radius: 10)
            VStack(alignment: .leading, spacing: 5){
                Text(product.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(product.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                    .frame(height: 40)
            }
        }
    }
}
