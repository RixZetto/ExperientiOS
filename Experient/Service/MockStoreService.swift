//
//  MockStoreService.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//

class MockStoreService: StoreServiceProtocol {
    
    var userName: String?
    var accessToken: String?
    var refreshToken: String?
    
    func clear() {
        self.userName = nil
        self.accessToken = nil
        self.refreshToken = nil
    }
    
    func saveUserName(_ name: String) {
        self.userName = name
    }
    
    func saveAccessToken(_ accessToken: String) {
        self.accessToken = accessToken
    }
    
    func saveRefreshToken(_ refreshToken: String) {
        self.refreshToken = refreshToken
    }
    
    func readUserName() -> String? {
        return self.userName
    }
    
    func readAccessToken() -> String? {
        return self.accessToken
    }
    
    func readRefreshToken() -> String? {
        return self.refreshToken
    }
    
}
