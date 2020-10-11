//
//  CartViewModel.swift
//  iCoffee
//

import Foundation
import Combine

class UserViewModel: ObservableObject {
    
    private var cancelBag: Set<AnyCancellable> = []
    
    let userService = UserService()
    
    @Published var isFinishedRegistration = false
    
    func updateCurrentUser(withValues: [String: Any]) {
        guard let currentUser = userService.currentUser else {
            return
        }
        updateUserPromise(user: currentUser, withValues: withValues)
            .sink(receiveCompletion: { completion in
                guard case .failure(let error) = completion else { return }
                debugPrint(error)
            }, receiveValue: { [weak self] user in
                self?.userService.saveLocally(user: user)
                self?.isFinishedRegistration = true
            })
            .store(in: &cancelBag)
    }
    
    deinit {
        for cancel in cancelBag {
            cancel.cancel()
        }
    }
}
