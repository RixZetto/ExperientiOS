//
//  HomeCoordinator.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//

import SwiftUI

class HomeCoordinator: ObservableObject {
    @Published var selectedTab: HomeTab = .dashboard
}

enum HomeTab: Hashable {
    case dashboard, settings
    
    var title: String {
        switch self {
        case .dashboard: return "Dashboard"
        case .settings: return "Settings"
        }
    }
    
    var icon: String {
        switch self {
        case .dashboard: return "house"
        case .settings: return "gear"
        }
    }
    
}
