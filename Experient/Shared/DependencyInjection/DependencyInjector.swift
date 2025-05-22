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
    func makeRouter() -> AppRouter
    func makeAuthManager() -> AuthManager
}

class DependencyInjector: ObservableObject, DependencyInjectorFactory {
    private let services: Services
    private let router = AppRouter()
    private lazy var authManager: AuthManager = {
        return AuthManager(authService: self.makeAuthService(), storeService: self.makeStoreService(), router: self.makeRouter())
    }()
    
    init(services: Services) {
        self.services = services
    }
    
    func makeStoreService() -> any StoreServiceProtocol {
        return services.storeService
    }
    
    func makeAuthService() -> any AuthServiceProtocol {
        return services.authService
    }
    
    func makeRouter() -> AppRouter {
        return router
    }
    
    func makeAuthManager() -> AuthManager {
        return self.authManager
    }
    
}
