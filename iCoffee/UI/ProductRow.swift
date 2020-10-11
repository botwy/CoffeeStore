//
//  ProductRow.swift
//  iCoffee
//

import SwiftUI

struct ProductRow: View {
    
    @ObservedObject var authViewModel: AuthViewModel
    
    var categoryName: String
    var products: [Product]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(categoryName)
                .font(.title)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(products) {drink in
                        NavigationLink(destination: ProductDetail(authViewModel: authViewModel, product: drink)) {
                            ProductItem(product: drink)
                                .frame(width: 300)
                                .padding(.trailing, 30)
                        }
                    }
                }
            }
        }
    }
}

struct DrinkRow_Previews: PreviewProvider {
    static var previews: some View {
        ProductRow(authViewModel: AuthViewModel(), categoryName: "HOT", products: [productDataMock])
    }
}
