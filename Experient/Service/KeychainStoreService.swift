//
//  KeychainStoreService.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//
import Security
import Foundation

class KeychainStoreService: StoreServiceProtocol {
    private let service = "com.experiente.challenge.rrodriguez"
    private let firstNameKey = "user.firstname"
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    
    init() {}
    
    // MARK: Public Methods
    func clear() {
        self.delete(forKey: firstNameKey)
        self.delete(forKey: accessTokenKey)
        self.delete(forKey: refreshTokenKey)
    }
    
    func saveUserName(_ name: String) {
        self.store(name, forKey: firstNameKey)
    }
    
    func saveAccessToken(_ accessToken: String) {
        self.store(accessToken, forKey: accessTokenKey)
    }
    
    func saveRefreshToken(_ refreshToken: String) {
        self.store(refreshToken, forKey: refreshTokenKey)
    }
    
    func readUserName() -> String? {
        return self.read(forKey: firstNameKey)
    }
    
    func readAccessToken() -> String? {
        return self.read(forKey: accessTokenKey)
    }
    
    func readRefreshToken() -> String? {
        return self.read(forKey: refreshTokenKey)
    }
    
    // MARK: Private methods
    
    private func store(_ value: String, forKey key: String) {
        if let data = value.data(using: .utf8) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service,
                kSecAttrAccount as String: key
            ]
            
            SecItemDelete(query as CFDictionary)
            
            let attributes: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service,
                kSecAttrAccount as String: key,
                kSecValueData as String: data
            ]
            
            SecItemAdd(attributes as CFDictionary, nil)
        }
    }
    
    private func read(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let data = result as? Data {
            let string = String(data: data, encoding: .utf8)
            return string
        }
        
        return nil
    }
    
    private func delete(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
    
}
