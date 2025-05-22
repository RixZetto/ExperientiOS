//
//  ContentView.swift
//  Experient
//
//  Created by youngvz on 5/20/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        if authManager.isValidating {
            ProgressView()
        }
        else {
            if authManager.isAuthenticated {
                HomeView()
            }
            else {
                LoginView()
            }
        }
        
    }
}

#Preview {
    ContentView().environmentObject(AuthManager(authService: MockAuthService(), storeService: MockStoreService()))
}
