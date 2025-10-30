import SwiftUI

// MARK: - Step 14: Value Proposition (Bridge)
struct ValuePropositionView: View {
    let onContinue: () -> Void
    @State private var showSections = [false, false, false]
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    Spacer()
                        .frame(height: 40)
                    
                    // Header
                    VStack(spacing: 8) {
                        Text("YOU TRIED ALONE.")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                            .tracking(2.0)
                        
                        Text("IT DIDN'T WORK.")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                            .tracking(2.0)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 8)
                    
                    // Section 1: Solo Attempts
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                            Text("SOLO ATTEMPTS")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.red)
                                .tracking(1.0)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            FailureRow(text: "Motivation faded")
                            FailureRow(text: "Excuses won")
                            FailureRow(text: "Nobody noticed")
                            FailureRow(text: "You gave up")
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
                    .opacity(showSections[0] ? 1 : 0)
                    .offset(y: showSections[0] ? 0 : 20)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.1), value: showSections[0])
                    
                    // Section 2: Tracking Apps
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "iphone.gen3")
                                .foregroundColor(.orange)
                            Text("TRACKING APPS")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.orange)
                                .tracking(1.0)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            FailureRow(text: "No real stakes")
                            FailureRow(text: "Easy to ignore")
                            FailureRow(text: "Just data")
                            FailureRow(text: "Nobody cares")
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.orange.opacity(0.05))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.orange.opacity(0.3), lineWidth: 2)
                    )
                    .padding(.horizontal, 24)
                    .opacity(showSections[1] ? 1 : 0)
                    .offset(y: showSections[1] ? 0 : 20)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.3), value: showSections[1])
                    
                    // Section 3: Pakkt Works
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("PAKKT WORKS")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.green)
                                .tracking(1.0)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            SuccessRow(text: "Real people watching")
                            SuccessRow(text: "Actual consequences")
                            SuccessRow(text: "Can't ignore it")
                            SuccessRow(text: "Your crew enforces")
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
                    .opacity(showSections[2] ? 1 : 0)
                    .offset(y: showSections[2] ? 0 : 20)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.5), value: showSections[2])
                    
                    // Transition
                    Text("Ready to build your pack?")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primary)
                        .padding(.top, 16)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    // Continue Button
                    Button(action: onContinue) {
                        HStack(spacing: 8) {
                            Text("LET'S BUILD IT")
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
            for index in 0..<showSections.count {
                showSections[index] = true
            }
        }
    }
}

private struct FailureRow: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "circle.fill")
                .font(.system(size: 6))
                .foregroundColor(.secondary)
            Text(text)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.primary)
        }
    }
}

private struct SuccessRow: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.green)
            Text(text)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    ValuePropositionView(onContinue: {})
}
