import SwiftUI

// MARK: - Step 6: Failed Approaches Visual (Pain - Breathing Step)
struct FailedApproachesVisualView: View {
    let onContinue: () -> Void
    @State private var showCards = [false, false, false, false]
    
    let approaches = [
        ("iphone.gen3", "Tracking Apps", nil),
        ("play.rectangle.fill", "Motivation Videos", nil),
        ("figure.2", "Gym Buddy", "(flaked)"),
        ("creditcard.fill", "Paid Programs", nil)
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
                    Text("YOU'VE TRIED EVERYTHING")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(2.0)
                        .padding(.horizontal, 24)
                    
                    // Graveyard Cards
                    ForEach(0..<approaches.count, id: \.self) { index in
                        VStack(spacing: 12) {
                            HStack(spacing: 16) {
                                Image(systemName: approaches[index].0)
                                    .font(.system(size: 32))
                                    .foregroundColor(.secondary)
                                    .frame(width: 40)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(approaches[index].1)
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.primary)
                                    
                                    if let subtitle = approaches[index].2 {
                                        Text(subtitle)
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                Spacer()
                                
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(.red)
                            }
                            .padding(20)
                        }
                        .padding(.horizontal, 24)
                        .opacity(showCards[index] ? 1 : 0)
                        .offset(y: showCards[index] ? 0 : 20)  .glassEffect(in: .rect(cornerRadius: 20))
                        .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(Double(index) * 0.2), value: showCards[index])
                    }
                    
                    // Key Message
                    VStack(spacing: 8) {
                        Text("They all failed because")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Text("there were NO REAL STAKES.")
                            .font(.system(size: 19, weight: .bold))
                            .foregroundColor(.primary)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.top, 16)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    // Continue Button
                    Button(action: onContinue) {
                        HStack(spacing: 8) {
                            Text("EXACTLY")
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
    FailedApproachesVisualView(onContinue: {})
}
