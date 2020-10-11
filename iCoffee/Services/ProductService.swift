//
//  ProductService.swift
//  iCoffee
//

import Foundation
import Combine
import CombineFirebase

final class ProductService {
    
    var firebasePublisher: AnyPublisher<[Product], Error> {
        FirebaseReference(.Menu).publisher(as: Product.self)
    }
}
