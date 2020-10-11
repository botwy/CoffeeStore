//
//  FinishRegistrationView.swift
//  iCoffee
//

import SwiftUI
import Combine

struct FinishRegistrationView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var userVM = UserViewModel()
    
    @State var name = ""
    @State var lastName = ""
    @State var telephone = ""
    @State var address = ""
    
    private var isFieldsCompleted: Bool {
        !name.isEmpty && !lastName.isEmpty && !telephone.isEmpty && !address.isEmpty
    }
    
    var body: some View {
        
        Form {
            Section() {
                Text("Завершение регистрации")
                    .fontWeight(.heavy)
                    .font(.largeTitle)
                    .padding([.top, .bottom], 20)
                TextField("Имя", text: $name)
                TextField("Фамилия", text: $lastName)
                TextField("Телефон", text: $telephone)
                TextField("Адрес", text: $address)
            }
            
            Section() {
                Button(action: {
                    finishRegistration()
                }, label: {
                    Text("Завершить регистрацию")
                })
            }
            .disabled(!isFieldsCompleted)
        }
        .onChange(of: userVM.isFinishedRegistration) {
            if $0 {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    
    private func finishRegistration() {
        let newValues = ["firstName": name, "lastName": lastName, "fullAddress": address, "phoneNumber": telephone]
        userVM.updateCurrentUser(withValues: newValues)
    }
}

struct FinishRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        FinishRegistrationView()
    }
}
