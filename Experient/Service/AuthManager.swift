//
//  AuthManager.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//
import Foundation

class AuthManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    private var expirationDate: Date?
    
    private var authService: AuthServiceProtocol
    private var storeService: StoreServiceProtocol
    
    init(authService: AuthServiceProtocol, storeService: StoreServiceProtocol) {
        self.authService = authService
        self.storeService = storeService
        
        // initialize
        self.initialize()
    }
    
    // MARK: - Login
    func login(username: String, password: String) async throws {
        guard !username.isEmpty, !password.isEmpty else {
            throw AuthError.invalidCredentials
        }
        
        do {
            let response = try await authService.authenticate(username: username, password: password)
            try self.setupToken(response: response)
        }
        catch let _ as AuthServiceError {
            throw AuthError.invalidCredentials
        }
        
    }
    
    // MARK: - Logout
    
    func logout() {
        self.clearTokens()
    }
    
    // MARK: - Private methods
    
    /// Load token from keychain and get the expiration date
    private func initialize() {
        guard let accessToken = self.storeService.readAccessToken() else {
            return
        }
        
        self.expirationDate = JWTDecoder().decodeJWTExpiration(from: accessToken)
    }
    
    /// Validate access Token expiration date and check if it can be refreshed
    private func validateSession() async -> Bool {
        guard let expirationDate = expirationDate else {
            return false
        }
        
        if expirationDate > Date() {
            return true // token is still alive
        }
        
        guard let refreshToken = self.storeService.readRefreshToken() else {
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
    
    private func scheduleRefreshToken() {
        
    }
    
    /// Setup all tokens after login
    private func setupToken(response: AuthResponse) throws {
        let accessToken = response.accessToken
        let refreshToken = response.refreshToken
        
        self.storeService.saveAccessToken(accessToken)
        self.storeService.saveRefreshToken(refreshToken)
        self.expirationDate = JWTDecoder().decodeJWTExpiration(from: accessToken)
        self.isAuthenticated = true
    }
    
    /// Clear all tokens after logout
    private func clearTokens() {
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
