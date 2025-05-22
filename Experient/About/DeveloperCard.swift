//
//  DeveloperCard.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//

import SwiftUI

struct DeveloperCard: View {
    let appName: String
    let devName: String
    let devEmail: String
    let devPortfolio: String
    let gitUrl: String
    
    var body: some View {
        VStack {
            
            Text(appName)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.blue)
            
            Text("Developed by: \(devName)")
                .font(.headline)
                .foregroundStyle(.primary)
            
            VStack(spacing: 10) {
                
                ButtonLink(
                    text: devEmail,
                    url: "mailto:\(devEmail)",
                    icon: "envelope"
                )
                
                ButtonLink(
                    text: "Portafolio",
                    url: devPortfolio,
                    icon: "briefcase"
                )
                
                ButtonLink(
                    text: "GitHub Repository",
                    url: gitUrl,
                    icon: "swift"
                )
                
            }
            .frame(maxWidth: 300)
            .padding(.top, 20)
            
        }
    }
}

// MARK: - ButtonLink Component

fileprivate struct ButtonLink : View {
    var text: String
    var url: String
    var icon: String
    
    var body: some View {
        Link(destination: URL(string: url)!) {
            Image(systemName: icon)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.blue)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
        }.buttonStyle(.bordered)
    }
    
}

#Preview {
    VStack {
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
    VStack {
        ButtonLink(text: "Text", url: "https://www.google.com", icon: "swift")
    }
}
