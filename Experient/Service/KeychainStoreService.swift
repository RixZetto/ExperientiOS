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
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    private let expirationKey = "expiration"
    
    init() {}
    
    // MARK: Public Methods
    func clear() {
        self.delete(forKey: accessTokenKey)
        self.delete(forKey: refreshTokenKey)
        self.delete(forKey: expirationKey)
    }
    
    func saveAccessToken(_ accessToken: String) {
        self.store(accessToken, forKey: accessTokenKey)
    }
    
    func saveRefreshToken(_ refreshToken: String) {
        self.store(refreshToken, forKey: refreshTokenKey)
    }
    
    func saveExpiration(_ expiration: Date) {
        let dateFormatter = ISO8601DateFormatter()
        let expirationString = dateFormatter.string(from: expiration)
        self.store(expirationString, forKey: expirationKey)
    }
    
    func readAccessToken() -> String? {
        return self.read(forKey: accessTokenKey)
    }
    
    func readRefreshToken() -> String? {
        return self.read(forKey: refreshTokenKey)
    }
    
    func readExpiration() -> Date? {
        guard let expirationString = self.read(forKey: expirationKey) else { return nil }
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: expirationString)
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
        var query: [String: Any] = [
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
