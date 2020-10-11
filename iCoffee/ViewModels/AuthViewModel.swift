//
//  CartViewModel.swift
//  iCoffee
//

import Foundation
import Combine

class AuthViewModel: ObservableObject {
    
    private var cancelBag: Set<AnyCancellable> = []
    
    let userService = UserService()
    
    let maxPinDigitCount = 6
    
    @Published var isLoading = false
    @Published var email = ""
    @Published var password = ""
    @Published var repeatPassword = ""
    
    @Published private(set) var pinDigits = [String]()
    @Published private(set) var wrongAttempts: Int = 0
    
    @Published private(set) var isLogin = false
    @Published private(set) var hasPin = false
    
    @Published var message = ""
    @Published var signupFinishMessage = ""
    
    private let digitPlaceholder = "1"
    
    init() {
        hasPin = Authentication.hasPin
    }
    
    var currentUser: User? {
        userService.currentUser
    }
    
    var isPinDigitsCompleteFilled: Bool {
        pinDigits.count == maxPinDigitCount
    }
    
    var isValidPin: Bool {
        Authentication.checkPin(pinDigits.joined())
    }
    
    func authWithBiometry() {
        guard Authentication.canUseBiometry && hasPin else { return }
        
        Authentication.checkPinWithBiometry { (success) in
            if success {
                self.pinDigits = (0...self.maxPinDigitCount).map{ _ in self.digitPlaceholder }
                self.loginWithPincode()
            }
        }
    }
    
    func loginWithPassword() {
        tryLogin(email: email.trimmed, password: password)
    }
    
    func logout() {
        Authentication.logOutCurrentUser()
            .sink { _ in
            } receiveValue: { [weak self] isLogouted in
                Authentication.clearKeychain()
                self?.isLogin = false
                self?.hasPin = Authentication.hasPin
                self?.clearModelData()
                self?.message = "Выход выполнен"
            }
            .store(in: &self.cancelBag)
    }
    
    func signup() {
        let email = self.email.trimmed
        guard !email.isEmpty && !password.isEmpty && !repeatPassword.isEmpty else {
            self.message = "Нужно заполнить email и пароль"
            return
        }
        guard password == repeatPassword else {
            self.message = "Повтор пароля не совпадает с паролем"
            return
        }
        Authentication.registerUserWith(email: email, password: password)
            .sink { (completion) in
                guard case .failure(let error) = completion else { return }
                self.message = error.localizedDescription
            } receiveValue: { [weak self] _ in
                self?.signupFinishMessage = "На ваш email отправлено письмо с подтверждением"
            }
            .store(in: &cancelBag)
    }
    
    func resetPassword() {
        let email = self.email.trimmed
        guard !email.isEmpty else {
            self.message = "Нужно заполнить email"
            return
        }
        resetPasswordPromise(email: email)
            .sink { (completion) in
                guard case .failure(let error) = completion else { return }
                self.message = error.localizedDescription
            } receiveValue: { [weak self] isReseted in
                if isReseted {
                    self?.signupFinishMessage = "На ваш email отправлено письмо для сброса пароля"
                }
            }
            .store(in: &cancelBag)
    }
    
    func digitPressForCheck(value: String) {
        if pinDigits.count < maxPinDigitCount {
            pinDigits.append(value)
        }
        loginWithPincodeIfPossible()
    }
    
    func appendDigitToPin(value: String) {
        if pinDigits.count < maxPinDigitCount {
            pinDigits.append(value)
        }
        if isPinDigitsCompleteFilled {
            savePasswordAndPincode()
        }
    }
    
    func removeLastPinDigit() {
        guard !pinDigits.isEmpty else {
            return
        }
        pinDigits.remove(at: pinDigits.index(before: pinDigits.endIndex))
    }
    
    deinit {
        for cancel in cancelBag {
            cancel.cancel()
        }
    }
}

private extension AuthViewModel {
    
    func savePasswordAndPincode() {
        Authentication.rememberPassword(self.password)
        Authentication.rememberPin(self.pinDigits.joined())
        pinDidRemember()
    }
    
    func pinDidRemember() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.hasPin = Authentication.hasPin
            self.clearModelData()
        }
    }
    
    func loginWithPincodeIfPossible() {
        if !isPinDigitsCompleteFilled {
            return
        }
        if !isValidPin {
            wrongAttempts += 1
        } else {
            loginWithPincode()
        }
    }
    
    func loginWithPincode() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            guard let credentials = Authentication.credentials else {
                return
            }
            let (login, password) = credentials
            self.tryLogin(email: login, password: password)
            if self.isLogin {
                self.clearModelData()
            }
        }
    }
    
    func tryLogin(email: String, password: String) {
        isLoading = true
        Authentication.loginUserWith(email: email, password: password)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                guard case .failure(let error) = completion else {
                    return
                }
                self?.login(isEmailVerified: false, error: error)
            }, receiveValue: { [weak self] userRs in
                guard let self = self else { return }
                if let user = userRs.user {
                    self.userService.saveLocally(user: user)
                } else {
                    self.userService.createFirestoreUser(userId: userRs.userId, email: self.email)
                }
                self.login(isEmailVerified: userRs.isEmailVerified, error: nil)
            })
            .store(in: &self.cancelBag)
    }
    
    func login(isEmailVerified: Bool, error: Error?) {
        guard error == nil else {
            self.message = error?.localizedDescription ?? ""
            return
        }
        if isEmailVerified {
            isLogin = true
        } else {
            self.message = "Email не подтвержден"
        }
    }
    
    func clearModelData() {
        message = ""
        email = ""
        password = ""
        repeatPassword = ""
        pinDigits = []
        wrongAttempts = 0
    }
}
