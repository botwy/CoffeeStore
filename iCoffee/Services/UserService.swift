//
//  ProductService.swift
//  iCoffee
//

import Foundation
import Combine
import Firebase
import CombineFirebase

final class UserService {
    
    private var userDefaults: UserDefaults {
        UserDefaults.standard
    }
    
    private var currentUserKey: String {
        User.UserDefaultsKey.currentUser.rawValue
    }
    
    var currentUserId: String? {
        Auth.auth().currentUser?.uid
    }
    
    var currentUser: User? {
        guard Auth.auth().currentUser != nil,
              let json = userDefaults.data(forKey: currentUserKey) else {
            return nil
        }
        return try? JSONDecoder().decode(User.self, from: json)
    }
    
    func createFirestoreUser(userId: String, email: String) {
        let user = User(id: userId, email: email, firstName: "", lastName: "", phoneNumber: "")
        saveLocally(user: user)
        saveToFirestore(user: user)
    }
    
    func removeCurrentUser() {
        userDefaults.removeObject(forKey: currentUserKey)
        userDefaults.synchronize()
    }
    
    func saveLocally(user: User) {
        let userJson = try? JSONEncoder().encode(user)
        userDefaults.set(userJson, forKey: currentUserKey)
        userDefaults.synchronize()
    }
    
    func saveToFirestore(user: User) {
        let userDictionary = user.defaultDictionary ?? [:]
        FirebaseReference(.User).document(user.id).setData(userDictionary) { (error) in
            if let error = error {
                print("Error creating user object: ", error.localizedDescription)
            }
        }
    }
    
    func updateCurrentUser(withValues: [String: Any]) -> AnyPublisher<Void, Error> {
        guard let currentUser = currentUser else {
            return Fail(error: User.UserError.missingUser).eraseToAnyPublisher()
        }
        return updateUserPromise(user: currentUser, withValues: withValues)
            .map { user in
                self.saveLocally(user: user)
            }
            .eraseToAnyPublisher()
    }
}
