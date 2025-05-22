//
//  Service.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//

/// This class should contains all the services used in the app
class Services {
    let authService: AuthServiceProtocol
    let storeService: StoreServiceProtocol
    
    init() {
        self.authService = MockAuthService(accessTokenExpirationInSeconds: 5 * 60) // default 5 min, for simulation and expire token
        self.storeService = KeychainStoreService()
    }
    
}
