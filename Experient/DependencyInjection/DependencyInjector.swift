//
//  DependencyInjector.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//
import SwiftUI

protocol DependencyInjectorFactory {
    func makeStoreService() -> StoreServiceProtocol
    func makeAuthService() -> AuthServiceProtocol
    func makeAuthManager() -> AuthManager
}

class DependencyInjector: ObservableObject, DependencyInjectorFactory {
    private let services: Services
    
    init(services: Services) {
        self.services = services
    }
    
    func makeStoreService() -> any StoreServiceProtocol {
        return services.storeService
    }
    
    func makeAuthService() -> any AuthServiceProtocol {
        return services.authService
    }
    
    
    func makeAuthManager() -> AuthManager {
        return AuthManager(authService: makeAuthService(), storeService: makeStoreService())
    }
    
}
