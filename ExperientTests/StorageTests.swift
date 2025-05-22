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
        
        #expect(keychainService.readUserName() == nil)
        #expect(keychainService.readAccessToken() == nil)
        #expect(keychainService.readRefreshToken() == nil)
        
        keychainService.saveUserName("demo_ricardo_rodriguez")
        keychainService.saveAccessToken("demo_token")
        keychainService.saveRefreshToken("demo_refresh_token")
        
        #expect(keychainService.readUserName() == "demo_ricardo_rodriguez")
        #expect(keychainService.readAccessToken() == "demo_token")
        #expect(keychainService.readRefreshToken() == "demo_refresh_token")
    }

    @Test func test_givenMockStore_whenStoringAndReading_thenSucceeds() async throws {
        let keychainService = MockStoreService()
        
        #expect(keychainService.readUserName() == nil)
        #expect(keychainService.readAccessToken() == nil)
        #expect(keychainService.readRefreshToken() == nil)
        
        keychainService.saveUserName("demo_ricardo_rodriguez")
        keychainService.saveAccessToken("demo_token")
        keychainService.saveRefreshToken("demo_refresh_token")
        
        #expect(keychainService.readUserName() == "demo_ricardo_rodriguez")
        #expect(keychainService.readAccessToken() == "demo_token")
        #expect(keychainService.readRefreshToken() == "demo_refresh_token")
    }
    
}
