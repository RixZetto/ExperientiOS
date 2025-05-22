//
//  DashboardViewModel.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//
import SwiftUI
import Combine

class DashboardViewModel: ObservableObject {
    private var authManager: AuthManager
    
    @Published var accessTokenExpirationDate: Date?
    @Published var refreshTokenExpirationDate: Date?
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(authManager: AuthManager) {
        self.authManager = authManager
        
        self.authManager.$accessTokenExpirationDate
            .sink { [weak self] newExpirationDate in
                self?.accessTokenExpirationDate = newExpirationDate
            }
            .store(in: &cancellables)
        
        self.authManager.$refreshTokenExpirationDate
            .sink { [weak self] newExpirationDate in
                self?.refreshTokenExpirationDate = newExpirationDate
            }
            .store(in: &cancellables)
    }
    
}
