//
//  MockStoreService.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//

class MockStoreService: StoreServiceProtocol {
    
    var accessToken: String?
    var refreshToken: String?
    
    func clear() {
        self.accessToken = nil
        self.refreshToken = nil
    }
    
    func saveAccessToken(_ accessToken: String) {
        self.accessToken = accessToken
    }
    
    func saveRefreshToken(_ refreshToken: String) {
        self.refreshToken = refreshToken
    }
    
    func readAccessToken() -> String? {
        return self.accessToken
    }
    
    func readRefreshToken() -> String? {
        return self.refreshToken
    }
    
}
