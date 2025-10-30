import SwiftUI

struct AuthView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Logo/Brand
                VStack(spacing: 16) {
                    Image(systemName: "seal.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.primary)
                    
                    Text("PAKKT")
                        .font(.system(size: 48, weight: .heavy))
                        .foregroundColor(.primary)
                    
                    Text("Accountability in Packs")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Loading indicator
                if authViewModel.isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .primary))
                            .scaleEffect(1.5)
                        
                        Text("Signing in...")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 40)
                } else if authViewModel.showEmailAuth {
                    // Email/Password Form
                    VStack(spacing: 16) {
                        TextField("Email", text: $authViewModel.email)
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .font(.system(size: 16))
                            .padding()
                            .glassEffect(in: .rect(cornerRadius: 12))
                        
                        SecureField("Password", text: $authViewModel.password)
                            .textContentType(authViewModel.isSignUpMode ? .newPassword : .password)
                            .font(.system(size: 16))
                            .padding()
                            .glassEffect(in: .rect(cornerRadius: 12))
                        
                        Button(action: {
                            Task {
                                if authViewModel.isSignUpMode {
                                    await authViewModel.signUpWithEmail()
                                } else {
                                    await authViewModel.signInWithEmail()
                                }
                                if authViewModel.isAuthenticated {
                                    coordinator.handleAuthenticationSuccess()
                                }
                            }
                        }) {
                            Text(authViewModel.isSignUpMode ? "SIGN UP" : "SIGN IN")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                        }
                        .glassEffect(in: .rect(cornerRadius: 30))
                        
                        Button(action: {
                            authViewModel.isSignUpMode.toggle()
                        }) {
                            Text(authViewModel.isSignUpMode ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                                .font(.system(size: 14))
                                .foregroundColor(.blue)
                        }
                        
                        Button(action: {
                            authViewModel.showEmailAuth = false
                        }) {
                            Text("Back to Apple Sign In")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal, 24)
                } else {
                    // Auth Buttons
                    VStack(spacing: 16) {
                        // Sign In with Apple
                        Button(action: {
                            Task {
                                await authViewModel.signInWithApple()
                                if authViewModel.isAuthenticated {
                                    coordinator.handleAuthenticationSuccess()
                                }
                            }
                        }) {
                            HStack {
                                Image(systemName: "applelogo")
                                    .font(.system(size: 20))
                                Text("Continue with Apple")
                                    .font(.system(size: 17, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .foregroundColor(.primary)
                        }
                        .glassEffect(in: .rect(cornerRadius: 30))
                        .disabled(authViewModel.isLoading)
                        
                        // Email/Password option for testing
                        Button(action: {
                            authViewModel.showEmailAuth = true
                        }) {
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .font(.system(size: 20))
                                Text("Continue with Email")
                                    .font(.system(size: 17, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .foregroundColor(.primary)
                        }
                        .glassEffect(in: .rect(cornerRadius: 30))
                        .disabled(authViewModel.isLoading)
                    }
                    .padding(.horizontal, 24)
                }
                
                // Terms
                Text("By continuing, you agree to our Terms & Privacy Policy")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
            }
        }
        .alert("Authentication Error", isPresented: $authViewModel.showError) {
            Button("OK") {
                authViewModel.clearError()
            }
        } message: {
            Text(authViewModel.errorMessage ?? "An unknown error occurred")
        }
        .onAppear {
            Task {
                await authViewModel.checkAuthStatus()
                if authViewModel.isAuthenticated {
                    coordinator.handleAuthenticationSuccess()
                }
            }
        }
    }
}

#Preview {
    AuthView()
        .environmentObject(AppCoordinator())
}
