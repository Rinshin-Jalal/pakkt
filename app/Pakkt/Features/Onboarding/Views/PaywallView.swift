import SwiftUI
import StoreKit

// MARK: - Step 27: Paywall (Commit - Final Step)
struct PaywallView: View {
    let onContinue: () -> Void
    @State private var isPurchasing = false
    @State private var showSuccess = false
    @State private var selectedPlan: PricingPlan = .yearly
    
    enum PricingPlan {
        case weekly, yearly
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            if showSuccess {
                // Success State
                VStack(spacing: 40) {
                    Spacer()
                    
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.primary)
                    
                    VStack(spacing: 12) {
                        Text("WELCOME TO PAKKT")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.primary)
                            .tracking(2.0)
                    }
                    
                    VStack(spacing: 12) {
                        Text("Your pack is waiting.")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Text("Your first check-in is soon.")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Text("Don't let them down.")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.primary)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    
                    Spacer()
                    
                    Button(action: onContinue) {
                        HStack(spacing: 8) {
                            Text("ENTER THE APP")
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
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            } else {
                // Paywall State
                ScrollView {
                    VStack(spacing: 32) {
                        Spacer()
                            .frame(height: 40)
                        
                        // Header
                        VStack(spacing: 12) {
                            Text("ACCOUNTABILITY THAT")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.primary)
                                .tracking(2.0)
                            
                            Text("ACTUALLY WORKS")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.primary)
                                .tracking(2.0)
                        }
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        
                        // Pricing Options
                        VStack(spacing: 12) {
                            // Weekly Plan
                            Button(action: {
                                selectedPlan = .weekly
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("WEEKLY")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.primary)
                                            .tracking(1.0)
                                        
                                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                                            Text("$3.99")
                                                .font(.system(size: 28, weight: .bold))
                                                .foregroundColor(.primary)
                                            Text("/week")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: selectedPlan == .weekly ? "checkmark.circle.fill" : "circle")
                                        .font(.system(size: 24))
                                        .foregroundColor(selectedPlan == .weekly ? .blue : .secondary)
                                }
                                .padding(20)
                                .frame(maxWidth: .infinity)
                                .glassEffect(in: .rect(cornerRadius: 30))
                               
                            }
                            
                            // Yearly Plan (Best Value)
                            ZStack(alignment: .topTrailing) {
                                Button(action: {
                                    selectedPlan = .yearly
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("YEARLY")
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(.primary)
                                                .tracking(1.0)
                                            
                                            HStack(alignment: .firstTextBaseline, spacing: 4) {
                                                Text("$59.99")
                                                    .font(.system(size: 28, weight: .bold))
                                                    .foregroundColor(.primary)
                                                Text("/year")
                                                    .font(.system(size: 14, weight: .medium))
                                                    .foregroundColor(.secondary)
                                            }
                                            
                                            Text("Save 70%")
                                                .font(.system(size: 13, weight: .semibold))
                                                .foregroundColor(.green)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: selectedPlan == .yearly ? "checkmark.circle.fill" : "circle")
                                            .font(.system(size: 24))
                                            .foregroundColor(selectedPlan == .yearly ? .blue : .secondary)
                                    }
                                    .padding(20)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(selectedPlan == .yearly ? Color.blue.opacity(0.1) : Color.secondary.opacity(0.05))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(selectedPlan == .yearly ? Color.blue : Color.secondary.opacity(0.3), lineWidth: 2)
                                    )
                                }
                                
                                // Free Trial Badge - Always visible for yearly
                                Text("7 DAYS FREE")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule()
                                            .fill(Color.green)
                                    )
                                    .offset(x: -10, y: -10)
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        // Features List
                        VStack(alignment: .leading, spacing: 12) {
                            PaywallFeatureRow(icon: "person.3.fill", text: "Your Pack (unlimited members)")
                            PaywallFeatureRow(icon: "bolt.fill", text: "Real Consequences & Phone Jail")
                            PaywallFeatureRow(icon: "hand.raised.fill", text: "Pack Voting & Accountability")
                            PaywallFeatureRow(icon: "bubble.left.and.bubble.right.fill", text: "Live Feed & Trash Talk")
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .glassEffect(in: .rect(cornerRadius: 30))
                        .padding(.horizontal, 24)
                        
                        Spacer()
                            .frame(height: 20)
                        
                        // Primary CTA
                        Button(action: startFreeTrial) {
                            HStack(spacing: 8) {
                                if isPurchasing {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text(selectedPlan == .yearly ? "START 7-DAY FREE TRIAL" : "SUBSCRIBE")
                                        .font(.system(size: 16, weight: .bold))
                                        .tracking(1.0)
                                    
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 14, weight: .bold))
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                        }
                        .buttonStyle(.glass)
                        .disabled(isPurchasing)
                        .padding(.horizontal, 24)
                        
                        // Terms
                        Text(selectedPlan == .yearly ? "Free for 7 days, then $59.99/year" : "$3.99 charged weekly")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        // Restore Purchase
                        Button(action: restorePurchase) {
                            Text("Restore Purchase")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        .padding(.bottom, 40)
                    }
                }
            }
        }
    }
    
    private func startFreeTrial() {
        isPurchasing = true
        
        // Simulate purchase flow
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isPurchasing = false
            withAnimation {
                showSuccess = true
            }
        }
    }
    
    private func restorePurchase() {
        // Implement restore logic
    }
}

private struct PaywallFeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.green)
                .frame(width: 20)
            
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.primary)
                .frame(width: 24)
            
            Text(text)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    PaywallView(onContinue: {})
}
