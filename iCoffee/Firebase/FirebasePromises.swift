//
//  FirebasePromises.swift
//  iCoffee
//

import Foundation
import Combine
import Firebase

struct UserRq {
    let userId: String
    let email: String?
    let isEmailVerified: Bool
}

struct UserRs {
    let userId: String
    let isEmailVerified: Bool
    let user: User?
}

func registerUserPromise(email: String, password: String) -> AnyPublisher<AuthDataResult, Error> {
    Future<AuthDataResult, Error> { promise in
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                promise(.failure(error))
            } else if let authDataResult = authDataResult {
                promise(.success(authDataResult))
            } else {
                promise(.failure(User.UserError.missingAuthUserData))
            }
        }
    }
    .eraseToAnyPublisher()
}

func loginPromise(email: String, password: String) -> AnyPublisher<AuthDataResult, Error> {
    Future<AuthDataResult, Error> { promise in
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                promise(.failure(error))
            } else if let authDataResult = authDataResult {
                promise(.success(authDataResult))
            } else {
                promise(.failure(User.UserError.missingAuthUserData))
            }
        }
    }
    .eraseToAnyPublisher()
}

func updateUserPromise(user: User, withValues: [String: Any]) -> AnyPublisher<User, Error> {
    Future<User, Error> { promise in
        FirebaseReference(.User).document(user.id).updateData(withValues) { (error) in
            if let error = error {
                promise(.failure(error))
            } else {
                var newUser = user
                newUser.update(withValues: withValues)
                promise(.success(newUser))
            }
        }
    }
    .eraseToAnyPublisher()
}

func downloadUserPromise(request: UserRq) -> AnyPublisher<UserRs, Error> {
    Future<UserRs, Error> { promise in
        FirebaseReference(.User).document(request.userId).getDocument { (snapshot, error) in
            if let error = error {
                promise(.failure(error))
            } else if let snapshot = snapshot, snapshot.exists,
                      let user: User = snapshot.decode() {
                let userRs = UserRs(userId: request.userId, isEmailVerified: request.isEmailVerified, user: user)
                promise(.success(userRs))
            } else {
                let userRs = UserRs(userId: request.userId, isEmailVerified: request.isEmailVerified, user: nil)
                promise(.success(userRs))
            }
        }
    }
    .eraseToAnyPublisher()
}

func sendEmailVerificationPromise(authDataResult: AuthDataResult) -> AnyPublisher<AuthDataResult, Error> {
    Future<AuthDataResult, Error> { promise in
        authDataResult.user.sendEmailVerification { (error) in
            if let error = error {
                debugPrint("verification email sent error is: ", error.localizedDescription)
                promise(.failure(error))
            } else {
                promise(.success(authDataResult))
            }
        }
    }
    .eraseToAnyPublisher()
}

func resetPasswordPromise(email: String) -> AnyPublisher<Bool, Error> {
    Future<Bool, Error> { promise in
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                promise(.failure(error))
            } else {
                promise(.success(true))
            }
        }
    }
    .eraseToAnyPublisher()
}

func logOutCurrentUserPromise() -> AnyPublisher<Bool, Error> {
    Future<Bool, Error> { promise in
        do {
            try Auth.auth().signOut()
            promise(.success(true))
        } catch let error {
            promise(.failure(error))
        }
    }
    .eraseToAnyPublisher()
}
