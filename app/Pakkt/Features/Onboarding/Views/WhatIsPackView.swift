import SwiftUI

// MARK: - Step 2: What Is A Pack (Hook)
struct WhatIsPackView: View {
    let onContinue: () -> Void
    @State private var showCards = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    Spacer()
                        .frame(height: 40)
                    
                    // Header
                    Text("WHAT IS A PACK?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(2.0)
                    
                    // Card 1: Your Crew
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 12) {
                            Image(systemName: "person.3.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.blue)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("YOUR CREW")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.primary)
                                    .tracking(1.0)
                                
                                Text("3-10 people who hold you accountable")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .padding(.horizontal, 20)
                    .opacity(showCards ? 1 : 0)
                    .offset(y: showCards ? 0 : 20)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.1), value: showCards)
                    
                    Text("+")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.secondary)
                    
                    // Card 2: Your Goal
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 12) {
                            Image(systemName: "target")
                                .font(.system(size: 32))
                                .foregroundColor(.green)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("YOUR GOAL")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.primary)
                                    .tracking(1.0)
                                
                                Text("The one thing you keep failing at")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .padding(.horizontal, 20)
                    .opacity(showCards ? 1 : 0)
                    .offset(y: showCards ? 0 : 20)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.3), value: showCards)
                    
                    Text("+")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.secondary)
                    
                    // Card 3: Real Consequences
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 12) {
                            Image(systemName: "bolt.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.orange)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("REAL CONSEQUENCES")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.primary)
                                    .tracking(1.0)
                                
                                Text("Cash fines. Phone jail. Pack votes.")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .padding(.horizontal, 20)
                    .opacity(showCards ? 1 : 0)
                    .offset(y: showCards ? 0 : 20)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.5), value: showCards)
                    
                    Text("=")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.secondary)
                    
                    // Result
                    HStack(spacing: 8) {
                        Text("SUCCESS")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primary)
                            .tracking(1.5)
                        
                        Image(systemName: "star.fill")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.yellow)
                    }
                    .opacity(showCards ? 1 : 0)
                    .scaleEffect(showCards ? 1 : 0.8)
                    .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.7), value: showCards)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    // Continue Button
                    Button(action: onContinue) {
                        HStack(spacing: 8) {
                            Text("CONTINUE")
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
        .onAppear {
            showCards = true
        }
    }
}

#Preview {
    WhatIsPackView(onContinue: {})
}
