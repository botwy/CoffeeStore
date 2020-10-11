//
//  ProductPromotion.swift
//  iCoffeeWidget
//

import Foundation

struct ProductPromotion: Codable, Equatable, Hashable {
    var name: String
    var imageName: String
    var oldPrice: Double
    var price: Double
}

let productPromotionMock = ProductPromotion(
    name: "Колд-брю",
    imageName: "cold brew",
    oldPrice: 125,
    price: 70
)
