//
//  DashboardView.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var authManager: AuthManager
    @StateObject var viewModel: DashboardViewModel
    
    init(authManager: AuthManager) {
        self._viewModel = StateObject(
            wrappedValue: DashboardViewModel(authManager: authManager)
        )
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Welcome \(authManager.userFirstName ?? "User")")
                .font(.title)
            
            if let accessTokenExpirationDate = viewModel.accessTokenExpirationDate {
                VStack(spacing: 4) {
                    Text("Access Token will expire in:")
                        .font(.caption)
                    CountdownView(targetDate: accessTokenExpirationDate)
                }
            } else {
                Text("Access Token is not defined")
            }
            
            if let refreshTokenExpirationDate = viewModel.refreshTokenExpirationDate {
                VStack(spacing: 4) {
                    Text("Refresh Token will expire in:")
                        .font(.caption)
                    CountdownView(targetDate: refreshTokenExpirationDate)
                }
            }
            else {
                Text("Refresh Token is not defined")
                
            }
            
            Button(action: {
                Task {
                    await authManager.logout()
                }
            }, label: {
                HStack {
                    Image(systemName: "lock.circle")
                    Text("Logout")
                }
            })
            .foregroundColor(.white)
            .padding()
            .background(
                Color.pink
            )
            .cornerRadius(8)
            Spacer()
        }
        
    }
    
}

#Preview {
    let storeService = MockStoreService()
    let authManager = AuthManager(
        authService: MockAuthService(),
        storeService: storeService,
        router: AppRouter()
    )
    DashboardView(authManager: authManager)
        .environmentObject(authManager)
}
