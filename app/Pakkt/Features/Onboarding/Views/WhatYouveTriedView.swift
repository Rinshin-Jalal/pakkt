import SwiftUI

// MARK: - Step 7: What You've Tried (Pain)
struct WhatYouveTriedView: View {
    let onContinue: () -> Void
    @Binding var failedApproaches: [String]
    
    let options = [
        ("iphone.gen3", "Tracking apps", "(Streaks, HabitNow...)"),
        ("play.rectangle.fill", "Motivation videos", "(Tony Robbins, etc.)"),
        ("figure.2", "Gym buddy / Partner", "(they flaked)"),
        ("creditcard.fill", "Paid programs", "($99-500 wasted)"),
        ("brain.head.profile", "Pure willpower", "(\"This time I mean it\")"),
        ("gift.fill", "Rewards system", "(treating yourself)")
    ]
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    Spacer()
                        .frame(height: 40)
                    
                    // Header
                    VStack(spacing: 16) {
                        Text("Which of these have")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("YOU tried?")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("(Select all that apply)")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    
                    // Options
                    VStack(spacing: 12) {
                        ForEach(options, id: \.1) { icon, title, subtitle in
                            Button(action: {
                                if failedApproaches.contains(title) {
                                    failedApproaches.removeAll { $0 == title }
                                } else {
                                    failedApproaches.append(title)
                                }
                            }) {
                                HStack(spacing: 16) {
                                    Image(systemName: failedApproaches.contains(title) ? "checkmark.square.fill" : "square")
                                        .font(.system(size: 24))
                                        .foregroundColor(failedApproaches.contains(title) ? .blue : .secondary)
                                    
                                    Image(systemName: icon)
                                        .font(.system(size: 24))
                                        .foregroundColor(.primary)
                                        .frame(width: 30)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(title)
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.primary)
                                        
                                        Text(subtitle)
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(failedApproaches.contains(title) ? Color.blue.opacity(0.1) : Color.secondary.opacity(0.05))
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // Message
                    if !failedApproaches.isEmpty {
                        VStack(spacing: 8) {
                            Text("All of these failed because")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            Text("there was no REAL accountability.")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.primary)
                        }
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.top, 8)
                    }
                    
                    Spacer()
                        .frame(height: 20)
                    
                    // Continue Button
                    Button(action: onContinue) {
                        HStack(spacing: 8) {
                            Text("SO WHAT WORKS?")
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
            }
        }
    }
}

#Preview {
    WhatYouveTriedView(onContinue: {}, failedApproaches: .constant([]))
}
