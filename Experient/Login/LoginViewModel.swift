//
//  LoginViewModel.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//
import SwiftUI

@MainActor
class LoginViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var password: String = ""
    
    @Published var isLoggingIn: Bool = false
    @Published var loginError: String?
    
    var authManager: AuthManager!
    
    var isFormValid: Bool {
        !username.isEmpty && !password.isEmpty
    }
    
    func login() async {
        isLoggingIn = true
        Task {
            do {
                try await authManager.login(username: username, password: password)
            } catch {
                loginError = error.localizedDescription
            }
            isLoggingIn = false
        }
        
    }
    
}
