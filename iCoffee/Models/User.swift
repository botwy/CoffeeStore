//
//  User.swift
//  iCoffee
//

import Foundation

struct User: Codable {
    let id: String
    var email: String
    var firstName: String = ""
    var lastName: String = ""
    var phoneNumber: String = ""
    var fullAddress: String = ""
    
    var fullName: String {
        firstName + " " + lastName
    }
}

extension User {
    
    enum UserError: Error {
        case missingAuthUserData
        case missingUserId
        case missingUser
    }
    
    enum UserDefaultsKey: String {
        case currentUser
    }
    
    var isCompleteFilled: Bool {
        !email.isEmpty && !firstName.isEmpty && !lastName.isEmpty && !phoneNumber.isEmpty && !fullAddress.isEmpty
    }
    
    mutating func update(withValues: [String: Any]) {
        if let email = withValues["email"] as? String {
            self.email = email
        }
        if let firstName = withValues["firstName"] as? String {
            self.firstName = firstName
        }
        if let lastName = withValues["lastName"] as? String {
            self.lastName = lastName
        }
        if let phoneNumber = withValues["phoneNumber"] as? String {
            self.phoneNumber = phoneNumber
        }
        if let fullAddress = withValues["fullAddress"] as? String {
            self.fullAddress = fullAddress
        }
    }
}
