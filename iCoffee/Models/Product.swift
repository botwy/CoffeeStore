//
//  Product.swift
//  iCoffee
//

import Foundation

enum Category: String, Codable {
    case hot
    case cold
    case filter
    
    var description: String {
        switch self {
        case .hot:
            return "горячие"
        case .cold:
            return "холодные"
        case .filter:
            return "фильтрованные"
        }
    }
}

struct Product: Codable, Identifiable, Equatable, Hashable {
    var id: String
    var name: String
    var imageName: String
    var category: Category
    var description: String
    var price: Double
}
