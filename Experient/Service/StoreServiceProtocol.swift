//
//  StoreServiceProtocol.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//

protocol StoreServiceProtocol {
    
    func clear()
    
    func saveUserName(_ name: String)
    
    func saveAccessToken(_ accessToken: String)
    
    func saveRefreshToken(_ refreshToken: String)
    
    func readUserName() -> String?
    
    func readAccessToken() -> String?
    
    func readRefreshToken() -> String?
    
}
