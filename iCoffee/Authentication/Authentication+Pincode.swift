//
//  Authenticate.swift
//  iCoffee
//

import Foundation
import LocalAuthentication
import KeychainAccess

extension Authentication {

    struct KeychainKey {
        private let login: String
        
        init(login: String) {
            self.login = login
        }
        
        var forPin: String { return "pin.\(login)" }
        
        var forPassword: String { return login }
    }
    
    static var login: String? {
        let userService = UserService()
        return userService.currentUser?.email
    }
    
    private static var keychainKey: KeychainKey? = {
        guard let login = login else { return nil }
        return KeychainKey(login: login)
    }()
    
    public static var canUseBiometry: Bool {
        var error: NSError?
        let context = LAContext()
        if(context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)) {
            return context.biometryType != .none
        }
        return false
    }
    
    public static func checkPinWithBiometry(completion: @escaping (Bool) -> Void) {
        guard canUseBiometry else {
            return completion(false)
        }
        let context = LAContext()
        let reason = NSLocalizedString("com.authentication.biometry.reason", value: "Используйте биометрию для входа в приложение", comment: "")
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, error) in
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
    
    public static func clearKeychain() {
        try? keychain.removeAll()
    }
    
    private static var pin: String? {
        guard let key = keychainKey?.forPin, let pin = try? keychain.get(key) else {
            return nil
        }
        return pin
    }
    
    public static var hasPin: Bool {
        return login != nil &&  pin != nil
    }
    
    public static func rememberPin(_ value: String) {
        guard let key = keychainKey?.forPin else { return }
        try? keychain.set(value, key: key)
    }
    
    public static func checkPin(_ value: String) -> Bool {
        guard let pin = pin else {
            return false
        }
        return pin == value
    }
    
    public static func rememberPassword(_ value: String) {
        guard let key = keychainKey?.forPassword else { return }
        try? keychain.set(value, key: key)
    }
    
    static var credentials: (login: String, password: String)? {
        guard let login = login else { return nil }
        guard let key = keychainKey?.forPassword else { return nil }
        guard let password = try? keychain.getString(key) else { return nil }
        
        return (login: login, password: password)
    }
    
    public static var keychain: Keychain = {
        return Keychain(service: "icoffee")
    }()
}
