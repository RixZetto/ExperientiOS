//
//  ExperientApp.swift
//  Experient
//
//  Created by youngvz on 5/20/25.
//

import SwiftUI

@main
struct ExperientApp: App {
    @StateObject var authManager: AuthManager
    @StateObject var router: AppRouter
    @StateObject var dependencies: DependencyInjector
    
    init() {
        let services = Services()
        let dependencies = DependencyInjector(services: services)
        let router = dependencies.makeRouter()
        let authManager = dependencies.makeAuthManager()
        
        self._dependencies = StateObject(wrappedValue: dependencies)
        self._authManager = StateObject(wrappedValue: authManager)
        self._router = StateObject(wrappedValue: router)
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
            .environmentObject(dependencies)
            .environmentObject(router)
            .environmentObject(authManager)
            .task {
                await authManager.bootstrap()
            }
        }
    }
}
