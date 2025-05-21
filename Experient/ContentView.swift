//
//  ContentView.swift
//  Experient
//
//  Created by youngvz on 5/20/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            LoginView()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
