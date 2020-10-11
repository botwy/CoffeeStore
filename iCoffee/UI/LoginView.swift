//
//  LoginView.swift
//  iCoffee
//

import SwiftUI

struct LoginView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var authViewModel: AuthViewModel
    
    @State var isShowSignup = false
    @State var isShowFinishRegistration = false
    @State var isShowAlert = false
    
    var body: some View {
        ZStack {
            if authViewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.blue))
                    .scaleEffect(2, anchor: .center)
            }
            VStack {
                renderHeader()
                
                VStack(alignment: .leading) {
                    renderFormFields()
                    renderForgotView()
                }
                .padding(.horizontal, 6)
                
                renderActionButton()
                
                SignupView(isShowSignup: $isShowSignup)
            }
        }
        .onChange(of: authViewModel.message, perform: { (message) in
            if !message.isEmpty {
                isShowAlert.toggle()
            }
        })
        .onChange(of: authViewModel.signupFinishMessage, perform: { (signupFinishMessage) in
            if !signupFinishMessage.isEmpty {
                isShowAlert.toggle()
            }
        })
        .alert(isPresented: $isShowAlert) {
            if !authViewModel.signupFinishMessage.isEmpty {
                return Alert(title: Text(authViewModel.signupFinishMessage), dismissButton: .default(Text("OK"), action: {
                    authViewModel.signupFinishMessage = ""
                    presentationMode.wrappedValue.dismiss()
                }))
            } else {
                return Alert(title: Text(authViewModel.message), dismissButton: .default(Text("OK"), action: {
                    authViewModel.message = ""
                }))
            }
        }
        .sheet(isPresented: $isShowFinishRegistration) {
            FinishRegistrationView()
        }
    }
    
    private func renderHeader() -> some View {
        Text(isShowSignup ? "Регистрация" : "Вход")
            .fontWeight(.heavy)
            .font(.largeTitle)
            .padding(.top, 40)
            .padding(.bottom, 20)
    }
    
    private func renderForgotView() -> some View {
        HStack {
            Spacer()
            Button(action: {
                authViewModel.resetPassword()
            }, label: {
                Text("Если забыли пароль")
                    .foregroundColor(Color.gray.opacity(0.5))
            })
        }
    }
    
    private func renderFormFields() -> some View {
        VStack(alignment: .leading) {
            Text("Email")
                .font(.headline)
                .fontWeight(.light)
                .foregroundColor(Color(.label))
                .opacity(0.75)
            TextField("Введите ваш email", text: $authViewModel.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            Divider()
            Text("Пароль")
                .font(.headline)
                .fontWeight(.light)
                .foregroundColor(Color(.label))
                .opacity(0.75)
            SecureField("Введите пароль", text: $authViewModel.password)
            Divider()
            
            if isShowSignup {
                Text("Повтор пароля")
                    .font(.headline)
                    .fontWeight(.light)
                    .foregroundColor(Color(.label))
                    .opacity(0.75)
                SecureField("Повторите введенный пароль", text: $authViewModel.repeatPassword)
                Divider()
            }
        }
        .padding(.bottom, 15)
        .animation(.easeInOut(duration: 0.2))
    }
    
    private func renderActionButton() -> some View {
        Button(action: {
            isShowSignup ? authViewModel.signup() : authViewModel.loginWithPassword()
        }, label: {
            Text(isShowSignup ? "Зарегистрироваться" : "Войти")
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 120)
                .padding()
        })
        .background(isFieldsCompleted ? Color.blue : Color.gray)
        .clipShape(Capsule())
        .padding(.top, 45)
        .disabled(!isFieldsCompleted)
    }
    
    private var isFieldsCompleted: Bool {
        isShowSignup ? isSignupFieldsCompleted : isLoginFieldsCompleted
    }
    
    private var isLoginFieldsCompleted: Bool {
        authViewModel.email.isEmail && !authViewModel.password.isEmpty
    }
    
    private var isSignupFieldsCompleted: Bool {
        authViewModel.email.isEmail && !authViewModel.password.isEmpty && authViewModel.password == authViewModel.repeatPassword
    }
}

struct SignupView: View {
    
    @Binding var isShowSignup: Bool
    
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 8) {
                Text(isShowSignup ? "Уже зарегистрированы" : "Нет аккаунта")
                    .foregroundColor(Color.gray.opacity(0.5))
                Button(action: {
                    isShowSignup.toggle()
                }, label: {
                    Text(isShowSignup ? "Вход" : "Регистрация")
                        .foregroundColor(.blue)
                })
            }
            .padding(.top, 25)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(authViewModel: AuthViewModel())
    }
}
