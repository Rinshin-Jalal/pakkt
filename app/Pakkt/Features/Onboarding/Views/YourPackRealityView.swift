import SwiftUI

// MARK: - Step 26: Your Pack Reality (Commit - Breathing Step)
struct YourPackRealityView: View {
    let onContinue: () -> Void
    @Binding var packName: String
    @Binding var packSize: Int
    @Binding var goalName: String
    @Binding var cashFine: Double
    @Binding var jailTimeMinutes: Int
    @State private var showComparison = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    Spacer()
                        .frame(height: 40)
                    
                    // Header
                    VStack(spacing: 8) {
                        Text("THIS IS YOUR PACK'S")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primary)
                            .tracking(2.0)
                        
                        Text("REALITY NOW")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primary)
                            .tracking(2.0)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    
                    // Their Pack Card
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 12) {
                            Image(systemName: "pawprint.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.blue)
                            
                            Text(packName.isEmpty ? "YOUR PACK" : packName.uppercased())
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.primary)
                                .tracking(1.0)
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "person.3.fill")
                                    .foregroundColor(.blue)
                                Text("\(packSize) Members")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.primary)
                            }
                            
                            HStack(spacing: 8) {
                                Image(systemName: "target")
                                    .foregroundColor(.green)
                                Text(goalName.isEmpty ? "Your goal" : goalName)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.primary)
                            }
                            
                            HStack(spacing: 8) {
                                Image(systemName: "dollarsign.circle.fill")
                                    .foregroundColor(.orange)
                                Text("Cash fine: $\(Int(cashFine))")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.primary)
                            }
                            
                            HStack(spacing: 8) {
                                Image(systemName: "lock.iphone")
                                    .foregroundColor(.orange)
                                Text("Phone jail: \(jailTimeMinutes) min")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.green.opacity(0.05))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.green.opacity(0.3), lineWidth: 2)
                    )
                    .padding(.horizontal, 24)
                    .opacity(showComparison ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2), value: showComparison)
                    
                    Text("VS")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.secondary)
                    
                    // Before Pakkt Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                            Text("BEFORE PAKKT")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.red)
                                .tracking(1.0)
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 10) {
                            FailureRow(text: "You tried alone")
                            FailureRow(text: "Apps didn't work")
                            FailureRow(text: "Nobody held you")
                            FailureRow(text: "You always quit")
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.red.opacity(0.05))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.red.opacity(0.3), lineWidth: 2)
                    )
                    .padding(.horizontal, 24)
                    .opacity(showComparison ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.4), value: showComparison)
                    
                    // Emotional Message
                    VStack(spacing: 12) {
                        Text("Now you have a crew.")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("Now you have stakes.")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("Now you'll succeed.")
                            .font(.system(size: 19, weight: .bold))
                            .foregroundColor(.green)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    // Continue Button
                    Button(action: onContinue) {
                        HStack(spacing: 8) {
                            Text("LET'S MAKE IT OFFICIAL")
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
            showComparison = true
        }
    }
}

private struct FailureRow: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "xmark")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.red)
            Text(text)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    YourPackRealityView(
        onContinue: {},
        packName: .constant("THE GYM WOLVES"),
        packSize: .constant(5),
        goalName: .constant("Gym"),
        cashFine: .constant(10),
        jailTimeMinutes: .constant(30)
    )
}
