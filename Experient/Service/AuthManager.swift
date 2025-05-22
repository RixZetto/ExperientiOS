//
//  AuthManager.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//
import Foundation
import SwiftUI

class AuthManager: ObservableObject {
    @Published var isValidating: Bool = true
    @Published var isAuthenticated: Bool = false
    @Published var userFirstName: String? // only storing the username to reused after login
    private var expirationDate: Date?
    
    private var authService: AuthServiceProtocol
    private var storeService: StoreServiceProtocol
    
    init(authService: AuthServiceProtocol, storeService: StoreServiceProtocol) {
        self.authService = authService
        self.storeService = storeService
    }
    
    // MARK: - Login
    
    func login(username: String, password: String) async throws {
        guard !username.isEmpty, !password.isEmpty else {
            throw AuthError.invalidCredentials
        }
        
        do {
            let response = try await authService.authenticate(username: username, password: password)
            try await self.setupToken(response: response)
        }
        catch _ as AuthServiceError {
            throw AuthError.invalidCredentials
        }
        
    }
    
    // MARK: - Logout
    
    func logout() async {
        await self.clearTokens()
    }
    
    // MARK: - Private methods
    
    /// Load token from keychain and get the expiration date
    @MainActor
    func initialize() async {
        guard let accessToken = self.storeService.readAccessToken() else {
            self.isValidating = false
            return
        }
        
        self.expirationDate = JWTDecoder().decodeJWTExpiration(from: accessToken)
        self.isAuthenticated = await self.validateSession()
    }
    
    /// Validate access Token expiration date and check if it can be refreshed
    @MainActor
    private func validateSession() async -> Bool {
        defer {
            self.isValidating = false
        }
        
        self.isValidating = true
        guard let expirationDate = expirationDate else {
            return false
        }
        
        if expirationDate > Date() {
            return true // token is still alive
        }
        
        guard let refreshToken = self.storeService.readRefreshToken() else {
            return false
        }
        
        guard let refreshTokenExpirationDate = JWTDecoder().decodeJWTExpiration(from: refreshToken) else {
            return false
        }
        
        if refreshTokenExpirationDate < Date() {
            // refresh token has expired
            return false
        }
        
        do {
            let refreshResponse = try await self.authService.refreshAccessToken(with: refreshToken)
            self.storeService.saveAccessToken(refreshResponse.accessToken)
            self.expirationDate = JWTDecoder().decodeJWTExpiration(from: refreshResponse.accessToken)
            return true
        } catch {
            return false
        }
    }
    
    
    /// Setup all tokens after login
    @MainActor
    private func setupToken(response: AuthResponse) async throws {
        let accessToken = response.accessToken
        let refreshToken = response.refreshToken
        
        self.storeService.saveUserName(response.user.firstName)
        self.storeService.saveAccessToken(accessToken)
        self.storeService.saveRefreshToken(refreshToken)
        self.expirationDate = JWTDecoder().decodeJWTExpiration(from: accessToken)
        
        self.userFirstName = response.user.firstName
        self.isAuthenticated = true
    }
    
    /// Clear all tokens after logout
    @MainActor
    private func clearTokens() async {
        self.storeService.clear()
        self.expirationDate = nil
        
        self.isAuthenticated = false
    }
    
}

// MARK: - Errors

enum AuthError: Error, LocalizedError {
    case invalidCredentials
    case refreshFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials: return "Invalid credentials"
        case .refreshFailed: return "Failed to refresh access token"
        }
    }
}
