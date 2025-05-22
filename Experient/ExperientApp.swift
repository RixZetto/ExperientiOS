//
//  ExperientApp.swift
//  Experient
//
//  Created by youngvz on 5/20/25.
//

import SwiftUI

@main
struct ExperientApp: App {
    @StateObject var authManager = AuthManager(authService: MockAuthService(accessTokenExpirationInSeconds: 5), storeService: KeychainStoreService())
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
                .task {
                    await authManager.initialize()
                }
        }
    }
}
