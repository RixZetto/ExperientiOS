//
//  LoginViewModel.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//
import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    
    @Published var isAboutPresented: Bool = false
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var isLoggingIn: Bool = false
    @Published var loginError: String?
    
    var authManager: AuthManager!
    
    private var cancellables = Set<AnyCancellable>()
    
    func setup(authManager: AuthManager) {
        self.authManager = authManager
        
        self.authManager.$isAuthenticated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                self?.isAuthenticated = newValue
            }
            .store(in: &cancellables)
    }
    
    var isFormValid: Bool {
        !username.isEmpty && !password.isEmpty
    }
    
    @MainActor
    func login() async {
        isLoggingIn = true
        try? await Task.sleep(nanoseconds: 1_000_000_000) // simulate 1 seconds
        do {
            try await authManager.login(username: username, password: password)
            loginError = nil
        } catch {
            loginError = error.localizedDescription
        }
        isLoggingIn = false
    }
    
    func showAbout() {
        isAboutPresented = true
    }
    
}
