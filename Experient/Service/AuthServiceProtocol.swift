//
//  AuthServiceProtocol.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//

protocol AuthServiceProtocol {
    
    func authenticate(username: String, password: String) async throws -> AuthResponse
    
    func validateToken(token: String) async -> Bool
    
    func refreshAccessToken(with refreshToken: String) async throws -> RefreshTokenResponse
    
}
