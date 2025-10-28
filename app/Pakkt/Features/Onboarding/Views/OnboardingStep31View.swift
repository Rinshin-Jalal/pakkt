import SwiftUI

struct OnboardingStep31View: View {
    let onContinue: () -> Void
    @State private var reminderSet = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Goal icon
                Image(systemName: "target")
                    .font(.system(size: 80))
                    .foregroundStyle(.green.opacity(0.9))
                    .padding(.bottom, 8)
                
                // Title
                Text("YOUR FIRST CHECK-IN")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                
                // Time card
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(.green)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Tomorrow Morning")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.primary)
                            
                            Text("7:00 AM - 9:00 AM")
                                .font(.system(size: 15))
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(20)
                    .glassEffect(in: .rect(cornerRadius: 20))
                    
                    HStack(spacing: 12) {
                        Image(systemName: "figure.run")
                            .font(.system(size: 24))
                            .foregroundStyle(.green)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Morning Run")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.primary)
                            
                            Text("Your pack's first goal")
                                .font(.system(size: 15))
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(20)
                    .glassEffect(in: .rect(cornerRadius: 20))
                }
                .padding(.horizontal, 24)
                
                // Warning text
                Text("Don't be the guy who pays")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                // Pack members preview
                VStack(spacing: 12) {
                    Text("YOUR PACK IS WATCHING")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .tracking(1.5)
                    
                    HStack(spacing: -8) {
                        ForEach(0..<4) { index in
                            Circle()
                                .fill(.secondary.opacity(0.2))
                                .frame(width: 44, height: 44)
                                .overlay {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 18))
                                        .foregroundStyle(.secondary)
                                }
                                .overlay {
                                    Circle()
                                        .stroke(Color(.systemBackground), lineWidth: 2)
                                }
                        }
                    }
                }
                .padding(.top, 8)
                
                Spacer()
                
                // Buttons
                VStack(spacing: 12) {
                    Button(action: {
                        withAnimation(.spring(response: 0.3)) {
                            reminderSet = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            onContinue()
                        }
                    }) {
                        HStack(spacing: 12) {
                            if reminderSet {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundStyle(.green)
                            } else {
                                Image(systemName: "bell.fill")
                                    .font(.system(size: 20))
                                    .foregroundStyle(.primary)
                            }
                            
                            Text(reminderSet ? "Reminder Set!" : "Set Reminder")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(.primary)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                    }
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .disabled(reminderSet)
                    
                    if reminderSet {
                        Text("We'll notify you 30 minutes before")
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                            .transition(.opacity)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .animation(.spring(response: 0.3), value: reminderSet)
    }
}

#Preview {
    OnboardingStep31View(onContinue: {})
}
