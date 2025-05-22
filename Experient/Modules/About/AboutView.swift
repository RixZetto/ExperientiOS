//
//  AboutView.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//
import SwiftUI

struct AboutView: View {
    
    var body: some View {
        DeveloperCard(
            appName: "Experient Challenge",
            devName: "Ricardo Rodríguez",
            devEmail: "rrodriguezgarcia@gmail.com",
            devPortfolio: "https://www.rixcode.dev",
            gitUrl: "https://github.com/RixZetto/ExperientiOS"
        )
    }
}

#Preview {
    AboutView()
}
