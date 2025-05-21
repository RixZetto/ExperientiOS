//
//  MockAuthService.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//
import Foundation

class MockAuthService: AuthServiceProtocol {
    
    let accessTokenExpirationInSeconds: TimeInterval
    let refreshTokenExpirationInSeconds: TimeInterval
    
    init(accessTokenExpirationInSeconds: TimeInterval = 5 * 60, // 5 min
         refreshTokenExpirationInSeconds: TimeInterval = 60 * 60 * 24 * 7 // 7 days
    ) {
        self.accessTokenExpirationInSeconds = accessTokenExpirationInSeconds
        self.refreshTokenExpirationInSeconds = refreshTokenExpirationInSeconds
    }

    func authenticate(username: String, password: String) async throws -> AuthResponse {
        guard !username.isEmpty, !password.isEmpty else {
            throw AuthServiceError.invalidCredentials
        }
        
        if username.lowercased() != "vshah" || password != "password" {
            throw AuthServiceError.invalidCredentials
        }
        
        let json = """
{
"username": "VShah",
"active": true,
"roleId": 20,
"dateCreated": "2018-03-02T00:00:00.000Z",
"dateModified": "2018-03-02T00:00:00.000Z",
"lastName": "Shah",
"firstName": "Viraj",
"displayName": "Viraj Shah",
"jiraUsername": "viraj.shah",
"intacctUserId": "EE-00112",
"userId": 41,
"emailAddress": "vshah@experient.com",
"openAtCurWeeksTimesheet": true,
"activeInterviewer": true,
"createIntacctTimesheet": true,
"roleName": "Developer"
}
"""

        let data = json.data(using: .utf8)!
        let user = try! JSONDecoder().decode(User.self, from: data)
        
        let accessToken = JWTGenerator.generate(
            name: "Internal Access Token",
            expirationInSeconds: accessTokenExpirationInSeconds) // 5 min
        
        let refreshToken = JWTGenerator.generate(
            name: "Refresh Token",
            expirationInSeconds: refreshTokenExpirationInSeconds) // 7 days
        
        return AuthResponse(
            user: user,
            accessToken: accessToken,
            refreshToken: refreshToken)
    }
    
    func validateToken(token: String) async -> Bool {
        return false
    }
    
    func refreshAccessToken(with refreshToken: String) async -> RefreshTokenResponse {
        return RefreshTokenResponse(accessToken: "")
    }
    
}

enum AuthServiceError: Error {
    case invalidCredentials
    case unkwnon
}
