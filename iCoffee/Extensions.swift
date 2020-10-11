//
//  Extensions.swift
//  iCoffee
//

import Foundation

extension Double {
    var clean: String {
        truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension Array {
    subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        
        return self[index]
    }
}

extension Encodable {
    var defaultDictionary: [String: Any]? {
        return try? dictionary(dateStrategy: JSONEncoder.DateEncodingStrategy.iso8601)
    }
    
    func dictionary(dateStrategy: JSONEncoder.DateEncodingStrategy) throws -> [String: Any] {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = dateStrategy
        let data = try encoder.encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            preconditionFailure("Error during converting encodable to dictionary \(String(describing: type(of: self)))")
        }
        
        return dictionary
    }
}

extension String {
    
    static var emailPattern: String {
        "[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+\\.[A-Za-z]{2,4}"
    }
    
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isEmail: Bool {
        trimmed.range(of: String.emailPattern, options: .regularExpression) != nil
    }
}
