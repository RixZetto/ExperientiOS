//
//  HomeView.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dependencies: DependencyInjector
    @StateObject var coordinator = HomeCoordinator()
    
    var body: some View {
        NavigationStack {
            TabView(selection: $coordinator.selectedTab) {
                DashboardView(authManager: dependencies.makeAuthManager())
                    .tabItem {
                        Label(HomeTab.dashboard.title, systemImage: HomeTab.dashboard.icon)
                    }
                    .tag(HomeTab.dashboard)
                
                SettingsView()
                    .tabItem {
                        Label(HomeTab.settings.title, systemImage: HomeTab.settings.icon)
                    }
                    .tag(HomeTab.settings)
                
            }
            .navigationTitle(coordinator.selectedTab.title)
        }
    }
    
}


#Preview {
    HomeView()
}
