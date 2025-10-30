import SwiftUI

// MARK: - Step 12: Live Pack Example (Relief - Breathing Step)
struct LivePackExampleView: View {
    let onContinue: () -> Void
    @State private var showExample = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    Spacer()
                        .frame(height: 40)
                    
                    // Header
                    Text("REAL PACK IN ACTION")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(2.0)
                    
                    // Pack Example Card
                    VStack(alignment: .leading, spacing: 0) {
                        // Pack Header
                        HStack(spacing: 12) {
                            Image(systemName: "pawprint.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("IRON WOLVES")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.primary)
                                    .tracking(1.0)
                                
                                Text("Gym • 4 members")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        .padding(20)
                        .background(Color.blue.opacity(0.1))
                        
                        Divider()
                        
                        // Feed Item
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Jake missed leg day")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.primary)
                                    
                                    Text("Yesterday 6:00 PM")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                            
                            HStack(spacing: 8) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                Text("MISSED CHECK-IN")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.red)
                                    .tracking(1.0)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.red.opacity(0.1))
                            )
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Pack voted:")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                HStack(spacing: 8) {
                                    Image(systemName: "bolt.fill")
                                        .foregroundColor(.orange)
                                    Text("1 hour phone jail")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(.primary)
                                }
                            }
                            
                            Divider()
                            
                            // Comments
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 8) {
                                    Image(systemName: "bubble.left.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(.secondary)
                                    Text("Comments:")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(.primary)
                                        .tracking(0.5)
                                }
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack(alignment: .top, spacing: 8) {
                                        Circle()
                                            .fill(Color.blue)
                                            .frame(width: 30, height: 30)
                                            .overlay(
                                                Text("M")
                                                    .font(.system(size: 14, weight: .bold))
                                                    .foregroundColor(.white)
                                            )
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Mike")
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(.primary)
                                            Text("Dude, again?! That's 3 this week")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    
                                    HStack(alignment: .top, spacing: 8) {
                                        Circle()
                                            .fill(Color.purple)
                                            .frame(width: 30, height: 30)
                                            .overlay(
                                                Text("S")
                                                    .font(.system(size: 14, weight: .bold))
                                                    .foregroundColor(.white)
                                            )
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Sarah")
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(.primary)
                                            Text("Better show up tomorrow or it's $20")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    
                                    HStack(alignment: .top, spacing: 8) {
                                        Circle()
                                            .fill(Color.orange)
                                            .frame(width: 30, height: 30)
                                            .overlay(
                                                Text("J")
                                                    .font(.system(size: 14, weight: .bold))
                                                    .foregroundColor(.white)
                                            )
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Jake")
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(.primary)
                                            Text("I know I know... no excuses tomorrow")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(20)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.secondary.opacity(0.05))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                    )
                    .padding(.horizontal, 24)
                    .opacity(showExample ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2), value: showExample)
                    
                    // Key Message
                    VStack(spacing: 8) {
                        Text("Your crew sees everything.")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("You can't hide.")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Text("That's why it works.")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.primary)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    // Continue Button
                    Button(action: onContinue) {
                        HStack(spacing: 8) {
                            Text("I WANT THIS")
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
            showExample = true
        }
    }
}

#Preview {
    LivePackExampleView(onContinue: {})
}
