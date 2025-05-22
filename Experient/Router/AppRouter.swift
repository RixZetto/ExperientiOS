//
//  AppRouter.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//
import SwiftUI

class AppRouter: ObservableObject {
    enum Route {
        case login
        case home
    }
    
    @Published var path: [Route] = []
    @Published var root: Route = .login
    
    func reset(to route: Route) {
        self.root = route
        self.path = []
    }
    
    func push(_ route: Route) {
        self.path.append(route)
    }
    
    func pop() {
        _ = path.popLast()
    }
}
