//
//  AuthManagerTests.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//

import Testing

struct AuthManagerTests {
    
    @Test func testLogin_Success_UpdatesIsLoggedInState() async throws {
        let keychainService = MockStoreService()
        
        let authManager = AuthManager(
            authService: MockAuthService(),
            storeService: keychainService,
            router: AppRouter()
        )
        
        #expect(authManager.isAuthenticated == false)
        try await authManager.login(username: "vshah", password: "password")
        #expect(authManager.isAuthenticated == true)
    }
    
    @Test func testRefreshToken_Success_GeneratesANewAccessToken() async throws {
        let keychainService = MockStoreService()
        keychainService.clear()
        
        let authManager = AuthManager(
            authService: MockAuthService(
                accessTokenExpirationInSeconds: 10 // simulate 5 seconds to invalidate accessToken
            ),
            storeService: keychainService,
            router: AppRouter()
        )
        
        try await authManager.login(username: "vshah", password: "password")
        
        #expect(authManager.isAuthenticated == true)
        
        let initialAccessToken = keychainService.readAccessToken()
        
        #expect(initialAccessToken != nil)
        
        // check in 1 sec if the accessToken is the same
        
        try await Task.sleep(for: .seconds(3))
        
        let accessTokenAfter3Secds = keychainService.readAccessToken()
        
        #expect(accessTokenAfter3Secds != nil)
        
        #expect(initialAccessToken == accessTokenAfter3Secds)
        
        // check after 10 seconds if the accessToken is different
        
        try await Task.sleep(for: .seconds(10))
        
        let refreshedAccessToken = keychainService.readAccessToken()
        
        #expect(refreshedAccessToken != nil)
        
        #expect(initialAccessToken != refreshedAccessToken)
        
    }
    
}
