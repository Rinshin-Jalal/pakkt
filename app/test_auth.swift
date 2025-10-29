import SwiftUI

// Simple test to verify authentication integration
struct TestAuthView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Authentication Test")
                .font(.largeTitle)
            
            Text("Is Authenticated: \(authViewModel.isAuthenticated ? "✅" : "❌")")
                .foregroundColor(authViewModel.isAuthenticated ? .green : .red)
            
            Button("Test Sign In") {
                Task {
                    await authViewModel.signInWithApple()
                }
            }
            .disabled(authViewModel.isLoading)
            
            if authViewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            }
            
            if authViewModel.showError {
                Text("Error: \(authViewModel.errorMessage ?? "Unknown error")")
                    .foregroundColor(.red)
            }
        }
        }
        .padding()
        .onAppear {
            Task {
                await authViewModel.checkAuthStatus()
            }
        }
    }
}

// Simple test to verify authentication integration
struct TestAuthView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Authentication Test")
                .font(.largeTitle)
            
            Text("Is Authenticated: \(authViewModel.isAuthenticated ? "✅" : "❌")")
                .foregroundColor(authViewModel.isAuthenticated ? .green : .red)
            
            Button("Test Sign In") {
                Task {
                    await authViewModel.signInWithApple()
                }
            }
            .disabled(authViewModel.isLoading)
            
            if authViewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            }
            
            if authViewModel.showError {
                Text("Error: \(authViewModel.errorMessage ?? "Unknown error")")
                    .foregroundColor(.red)
            }
        }
        }
        .padding()
        .onAppear {
            Task {
                await authViewModel.checkAuthStatus()
            }
        }
    }
}
