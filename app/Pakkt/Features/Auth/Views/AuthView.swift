import SwiftUI

struct AuthView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
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
                
                // Auth Buttons
                VStack(spacing: 16) {
                    // Sign In with Apple
                    Button(action: {
                        // TODO: Implement Sign In with Apple
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
                    
                    // Sign In with Google
                    Button(action: {
                        // TODO: Implement Sign In with Google
                    }) {
                        HStack {
                            Image(systemName: "globe")
                                .font(.system(size: 20))
                            Text("Continue with Google")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .foregroundColor(.primary)
                    }
                    .glassEffect(in: .rect(cornerRadius: 30))
                }
                .padding(.horizontal, 24)
                
                // Terms
                Text("By continuing, you agree to our Terms & Privacy Policy")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    AuthView()
        .environmentObject(AppCoordinator())
}
