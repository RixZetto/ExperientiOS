//
//  StorageTests.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//
import Testing
import Foundation

struct StorageTests {

    @Test func test_givenKeychainStorage_whenStoringAndReading_thenSucceeds() async throws {
        let keychainService = KeychainStoreService()
        keychainService.clear()
        
        #expect(keychainService.readAccessToken() == nil)
        #expect(keychainService.readRefreshToken() == nil)
        #expect(keychainService.readExpiration() == nil)
        
        keychainService.saveAccessToken("demo_token")
        keychainService.saveRefreshToken("demo_refresh_token")
        keychainService.saveExpiration(Date().addingTimeInterval(3600))
        
        #expect(keychainService.readAccessToken() == "demo_token")
        #expect(keychainService.readRefreshToken() == "demo_refresh_token")
        #expect(keychainService.readExpiration() != nil)
    }

    @Test func test_givenMockStore_whenStoringAndReading_thenSucceeds() async throws {
        let keychainService = MockStoreService()
        
        #expect(keychainService.readAccessToken() == nil)
        #expect(keychainService.readRefreshToken() == nil)
        
        keychainService.saveAccessToken("demo_token")
        keychainService.saveRefreshToken("demo_refresh_token")
        
        #expect(keychainService.readAccessToken() == "demo_token")
        #expect(keychainService.readRefreshToken() == "demo_refresh_token")
    }
    
}
