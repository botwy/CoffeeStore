//
//  MenuViewModel.swift
//  iCoffee
//

import Foundation
import Combine
import Firebase
import CodableFirebase

class ProductViewModel: ObservableObject {
    
    private var cancelBag: Set<AnyCancellable> = []
    private let service = ProductService()
    
    @Published var products: [Product] = []
    
    init() {
        activateFirebaseListener()
    }
    
    private func activateFirebaseListener() {
        service.firebasePublisher
            .sink(receiveCompletion: { completion in
                guard case .failure(let error) = completion else { return }
                debugPrint(error)
            }, receiveValue: { [weak self] products in
                self?.products = products
            })
            .store(in: &cancelBag)
    }
    
    deinit {
        for cancel in cancelBag {
            cancel.cancel()
        }
    }
}
