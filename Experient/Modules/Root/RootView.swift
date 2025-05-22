//
//  RootView.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        ZStack {
            if authManager.isValidating {
                Text("One moment...")
                ProgressView()
            } else {
                switch self.router.root {
                case .login:
                    LoginView()
                        .transition(.move(edge: .leading))
                case .home:
                    HomeView()
                        .transition(.move(edge: .trailing))
                }
            }
            
        }
        .animation(.easeInOut, value: self.router.root)
    }
}
