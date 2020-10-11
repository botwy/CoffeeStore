//
//  Auth.swift
//  iCoffee
//

import Foundation
import Combine
import FirebaseAuth
import CodableFirebase


class Authentication {
    
    static func loginUserWith(email: String, password: String) -> AnyPublisher<UserRs, Error> {
        
        return loginPromise(email: email, password: password)
            .flatMap { (authDataResult: AuthDataResult) -> AnyPublisher<UserRs, Error> in
                let user = authDataResult.user
                let userRequest = UserRq(userId: user.uid, email: user.email, isEmailVerified: user.isEmailVerified)
                
                return downloadUserPromise(request: userRequest)
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    static func registerUserWith(email: String, password: String) -> AnyPublisher<AuthDataResult, Error> {
        return registerUserPromise(email: email, password: password)
            .flatMap { sendEmailVerificationPromise(authDataResult: $0) }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    static func resetPassword(email: String) -> AnyPublisher<Bool, Error> {
        return resetPasswordPromise(email: email)
    }
    
    static func logOutCurrentUser() -> AnyPublisher<Bool, Error> {
        return logOutCurrentUserPromise()
    }
}
