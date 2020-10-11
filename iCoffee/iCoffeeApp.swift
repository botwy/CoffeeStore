//
//  iCoffeeApp.swift
//  iCoffee
//

import SwiftUI
import Firebase

@main
struct iCoffeeApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
        }
    }
}
