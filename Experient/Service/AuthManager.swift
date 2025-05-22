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
    @Published var accessTokenExpirationDate: Date? {
        didSet {
            if let accessTokenExpirationDate = accessTokenExpirationDate {
                self.startRefreshTimer(expiration: accessTokenExpirationDate)
            }
        }
    }
    @Published var refreshTokenExpirationDate: Date?
    private var refreshTimer: Timer?
    
    private var authService: AuthServiceProtocol
    private var storeService: StoreServiceProtocol
    private var router: AppRouter
    
    
    init(authService: AuthServiceProtocol, storeService: StoreServiceProtocol, router: AppRouter) {
        self.authService = authService
        self.storeService = storeService
        self.router = router
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
    func bootstrap() async {
        guard let accessToken = self.storeService.readAccessToken(),
              let refreshToken = self.storeService.readRefreshToken()
        else {
            self.router.reset(to: .login)
            self.isValidating = false
            return
        }
        
        self.accessTokenExpirationDate = JWTDecoder().decodeJWTExpiration(from: accessToken)
        self.refreshTokenExpirationDate = JWTDecoder().decodeJWTExpiration(from: refreshToken)
        
        let isValidSession = await self.validateSession()
        self.isAuthenticated = isValidSession
        if isValidSession {
            self.router.reset(to: .home)
        } else {
            self.router.reset(to: .login)
        }
    }
    
    private func startRefreshTimer(expiration: Date) {
        self.refreshTimer?.invalidate()
        
        let interval = expiration.timeIntervalSinceNow
        self.refreshTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            Task {
                if await self?.validateSession() == false {
                    await self?.logout()
                }
            }
        }
    }
    
    /// Validate access Token expiration date and check if it can be refreshed
    @MainActor
    private func validateSession() async -> Bool {
        defer {
            self.isValidating = false
        }
        
        self.isValidating = true
        
        if self.accessTokenExpirationDate != nil && self.accessTokenExpirationDate! > Date() {
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
            self.accessTokenExpirationDate = JWTDecoder().decodeJWTExpiration(from: refreshResponse.accessToken)
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
        self.accessTokenExpirationDate = JWTDecoder().decodeJWTExpiration(from: accessToken)
        self.refreshTokenExpirationDate = JWTDecoder().decodeJWTExpiration(from: refreshToken)
        self.userFirstName = response.user.firstName
        self.isAuthenticated = true
        self.router.reset(to: .home)
    }
    
    /// Clear all tokens after logout
    @MainActor
    private func clearTokens() async {
        self.storeService.clear()
        self.accessTokenExpirationDate = nil
        
        self.isAuthenticated = false
        self.router.reset(to: .login)
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
