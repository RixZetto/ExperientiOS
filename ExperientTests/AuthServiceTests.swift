//
//  AuthServiceTests.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//

import Testing
import Foundation

struct AuthServiceTests {
    
    @Test func testAuthenticationWithValidCredentials() async throws {
        let authService: AuthServiceProtocol = MockAuthService()
        let response = try await authService.authenticate(
            username: "vshah", password: "password")
        #expect(response.user.username == "VShah")
        #expect(response.accessToken != nil, "Access token should not be nil")
        #expect(response.refreshToken != nil, "Refresh token should not be nil")
    }
    
    @Test func testAuthenticationWithInvalidCredentials() async {
        let authService: AuthServiceProtocol = MockAuthService()
        do {
            _ = try await authService.authenticate(
                username: "vshah", password: "123123")
            #expect(Bool(false), "Expected authentication to fail")
        } catch let error as AuthServiceError {
            #expect(error == .invalidCredentials)
        } catch {
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }
    
    @Test func testAuthenticationWithEmptyCredentials() async {
        let authService: AuthServiceProtocol = MockAuthService()
        do {
            _ = try await authService.authenticate(
                username: "", password: "")
            #expect(Bool(false), "Expected authentication to fail")
        } catch let error as AuthServiceError {
            #expect(error == .invalidCredentials)
        } catch {
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }
    
    @Test func testAuthenticationAndValidateAccessTokenExpirationDate() async throws {
        let authService: AuthServiceProtocol = MockAuthService()
        let response = try await authService.authenticate(
            username: "vshah", password: "password")
        
        let expectedInterval: TimeInterval = 5 * 60 // 5 minutes

        let accessToken = response.accessToken
        let expirationDate = JWTDecoder().decodeJWTExpiration(from: accessToken)
        #expect(expirationDate != nil)
        #expect(expirationDate! > Date())
        
        let actualInterval = expirationDate!.timeIntervalSinceNow
        #expect(abs(actualInterval - expectedInterval) < 10, "The accessToken expiration is not correct")
    }
    
    @Test func testAuthenticationAndValidateRefreshTokenExpirationDate() async throws {
        let authService: AuthServiceProtocol = MockAuthService()
        let response = try await authService.authenticate(
            username: "vshah", password: "password")
        
        let expectedInterval: TimeInterval = 60 * 60 * 24 * 7 // 7 days

        let refreshToken = response.refreshToken
        let expirationDate = JWTDecoder().decodeJWTExpiration(from: refreshToken)
        #expect(expirationDate != nil)
        #expect(expirationDate! > Date())
        
        let actualInterval = expirationDate!.timeIntervalSinceNow
        #expect(abs(actualInterval - expectedInterval) < 10, "The refreshToken expiration date is not correct")
    }
}
