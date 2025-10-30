import SwiftUI

// MARK: - Step 1: Welcome To Pakkt (Hook)
struct WelcomeToPacktView: View {
    let onContinue: () -> Void
    @State private var showLogo = false
    @State private var showHeader = false
    @State private var showBody = false
    @State private var showButton = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Logo
                Image(systemName: "pawprint.fill")
                    .font(.system(size: 80, weight: .regular))
                    .foregroundColor(.primary)
                    .opacity(showLogo ? 1 : 0)
                    .scaleEffect(showLogo ? 1 : 0.5)
                    .animation(.easeOut(duration: 0.4), value: showLogo)
                
                // Header
                VStack(spacing: 12) {
                    Text("THERE'S A REASON")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(2.0)
                    
                    Text("YOU KEEP FAILING")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(2.0)
                }
                .opacity(showHeader ? 1 : 0)
                .offset(y: showHeader ? 0 : 20)
                .animation(.easeOut(duration: 0.5).delay(0.3), value: showHeader)
                
                // Body Text
                VStack(spacing: 8) {
                    Text("You've tried willpower.")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.secondary)
                    
                    Text("You've tried apps.")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.secondary)
                    
                    Text("There's a better way.")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.primary)
                }
                .multilineTextAlignment(.center)
                .opacity(showBody ? 1 : 0)
                .animation(.easeOut(duration: 0.4).delay(0.8), value: showBody)
                
                Spacer()
                
                // Continue Button
                Button(action: onContinue) {
                    HStack(spacing: 8) {
                        Text("LET'S FIND OUT")
                            .font(.system(size: 16, weight: .bold))
                            .tracking(1.0)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                }
                .buttonStyle(.glass)
                .opacity(showButton ? 1 : 0)
                .offset(y: showButton ? 0 : 20)
                .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(1.2), value: showButton)
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            showLogo = true
            showHeader = true
            showBody = true
            showButton = true
        }
    }
}

#Preview {
    WelcomeToPacktView(onContinue: {})
}
