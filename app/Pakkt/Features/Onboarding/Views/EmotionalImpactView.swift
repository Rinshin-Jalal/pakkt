import SwiftUI

// MARK: - Step 8: Emotional Impact (Pain)
struct EmotionalImpactView: View {
    let onContinue: () -> Void
    @Binding var emotionalImpact: String
    @FocusState private var isFieldFocused: Bool
    
    let emotions = [
        ("face.frowning", "Ashamed"),
        ("face.frustrated", "Frustrated"),
        ("face.disappointed", "Disappointed"),
        ("person.crop.circle.badge.xmark", "Like a failure")
    ]
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    Spacer()
                        .frame(height: 40)
                    
                    // Header
                    VStack(spacing: 16) {
                        Text("Be honest with yourself.")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Text("How does it feel when you fail again?")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 32)
                    
                    // Text Area
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $emotionalImpact)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.primary)
                            .frame(height: 140)
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                            .padding(12)
                            .focused($isFieldFocused)
                        
                        if emotionalImpact.isEmpty {
                            Text("Type your answer...")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.secondary)
                                .padding(.leading, 16)
                                .padding(.top, 20)
                                .allowsHitTesting(false)
                        }
                    }
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .padding(.horizontal, 24)

                        
                    
                    // Emotion Pills
                    VStack(alignment: .leading, spacing: 12) {
                        Text("OR CHOOSE:")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.secondary)
                            .tracking(1.0)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(emotions, id: \.1) { icon, emotion in
                                Button(action: {
                                    emotionalImpact = emotion
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: icon)
                                            .font(.system(size: 18))
                                        Text(emotion)
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                }
                                .buttonStyle(.glass)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    
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
                    .disabled(emotionalImpact.isEmpty)
                    .opacity(emotionalImpact.isEmpty ? 0.5 : 1.0)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

#Preview {
    EmotionalImpactView(onContinue: {}, emotionalImpact: .constant(""))
}
