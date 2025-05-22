//
//  DashboardView.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Welcome \(authManager.userFirstName ?? "User")")
                .font(.title)
            
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
    DashboardView()
        .environmentObject(AuthManager(authService: MockAuthService(), storeService: MockStoreService()))
}
