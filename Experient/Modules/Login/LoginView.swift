//
//  LoginView.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//
import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var authManager: AuthManager
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.purple, .blue]),
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            

            ScrollView {
                VStack(spacing: 16) {
                    Spacer()
                    
                    VStack {
                        Image("iTunesArtwork")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .shadow(color: Color.white, radius: 5)
                        Text("Experient Challenge")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 30)
                    }
                    .padding()
                    
                    TextField("Username", text: $viewModel.username)
                        .padding()
                        .background(Color(.systemGray6).opacity(0.8))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                    
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .background(Color(.systemGray6).opacity(0.8))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
               
                    
                    // Error Message when failing
                    if let error = viewModel.loginError {
                        HStack(alignment: .center, spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.white)
                            
                            Text(error.localizedCapitalized)
                        }
                        .font(.callout)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.2))
                        .cornerRadius(8)
                    }
                    
                    
                    // Login Button
                    Button {
                        guard viewModel.isLoggingIn == false else { return }
                        Task {
                            await viewModel.login()
                        }
                    } label: {
                        ZStack {
                            Text("Login")
                                .opacity(viewModel.isLoggingIn ? 0 : 1)
                                .foregroundColor(.white)
                                .bold()
                            
                            if viewModel.isLoggingIn {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                        }
                        .frame(height: 32)
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(
                        Color.pink
                    )
                    .cornerRadius(8)
                    .disabled(viewModel.isLoggingIn)
                    .contentShape(Rectangle())
                    
                    
                    // About Button
                    Button {
                        Task {
                            self.viewModel.showAbout()
                        }
                    } label: {
                        Text("About")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.blue)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                            .cornerRadius(10)
                    }.contentShape(Rectangle())
                    
                    Spacer()
                }
                .padding()
                .scrollDismissesKeyboard(.interactively)
                
            }
            
        }.onAppear {
            self.viewModel.setup(authManager: authManager)
        }.sheet(isPresented: $viewModel.isAboutPresented) {
            Group {
                AboutView()
            }.accessibilityIdentifier("AboutSheet")
                .presentationDetents([.medium, .large])
                .padding(10)
            
        }
        
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthManager(
            authService: MockAuthService(),
            storeService: MockStoreService(),
            router: AppRouter()))
}
