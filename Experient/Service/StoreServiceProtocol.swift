//
//  StoreServiceProtocol.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//

protocol StoreServiceProtocol {
    
    func clear()
    
    func saveAccessToken(_ accessToken: String)
    
    func saveRefreshToken(_ refreshToken: String)
    
    func readAccessToken() -> String?
    
    func readRefreshToken() -> String?
    
}
