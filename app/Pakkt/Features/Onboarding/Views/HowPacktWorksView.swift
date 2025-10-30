import SwiftUI

// MARK: - Step 11: How Pakkt Works (Relief - Breathing Step)
struct HowPacktWorksView: View {
    let onContinue: () -> Void
    @State private var showCards = [false, false, false]
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    Spacer()
                        .frame(height: 40)
                    
                    // Header
                    Text("HERE'S HOW IT WORKS")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(2.0)
                    
                    // Step 1
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 12) {
                            Text("[1]")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.blue)
                            
                            HStack(spacing: 8) {
                                Image(systemName: "person.3.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.blue)
                                Text("YOUR CREW")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.primary)
                                    .tracking(1.0)
                            }
                        }
                        
                        Text("3-10 people who see everything you do")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .padding(.horizontal, 20)
                    .opacity(showCards[0] ? 1 : 0)
                    .offset(y: showCards[0] ? 0 : 20)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.1), value: showCards[0])
                    
                    Text("+")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.secondary)
                    
                    // Step 2
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 12) {
                            Text("[2]")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.green)
                            
                            HStack(spacing: 8) {
                                Image(systemName: "target")
                                    .font(.system(size: 20))
                                    .foregroundColor(.green)
                                Text("YOUR GOAL")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.primary)
                                    .tracking(1.0)
                            }
                        }
                        
                        Text("Check in daily at your committed time")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .padding(.horizontal, 20)
                    .opacity(showCards[1] ? 1 : 0)
                    .offset(y: showCards[1] ? 0 : 20)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.3), value: showCards[1])
                    
                    Text("+")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.secondary)
                    
                    // Step 3
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 12) {
                            Text("[3]")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.orange)
                            
                            HStack(spacing: 8) {
                                Image(systemName: "bolt.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.orange)
                                Text("REAL CONSEQUENCES")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.primary)
                                    .tracking(1.0)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Miss? Your pack votes.")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            Text("Cash fine or phone jail")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            Text("You CAN'T escape.")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .padding(.horizontal, 20)
                    .opacity(showCards[2] ? 1 : 0)
                    .offset(y: showCards[2] ? 0 : 20)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.5), value: showCards[2])
                    
                    Text("=")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.secondary)
                    
                    // Result
                    HStack(spacing: 8) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.yellow)
                        Text("SUCCESS")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primary)
                            .tracking(1.5)
                    }
                    .opacity(showCards[2] ? 1 : 0)
                    .scaleEffect(showCards[2] ? 1 : 0.8)
                    .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.7), value: showCards[2])
                    
                    Spacer()
                        .frame(height: 20)
                    
                    // Continue Button
                    Button(action: onContinue) {
                        HStack(spacing: 8) {
                            Text("SEE IT IN ACTION")
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
            for index in 0..<showCards.count {
                showCards[index] = true
            }
        }
    }
}

#Preview {
    HowPacktWorksView(onContinue: {})
}
