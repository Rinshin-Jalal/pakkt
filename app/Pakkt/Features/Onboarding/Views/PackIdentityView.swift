import SwiftUI

struct PackIdentityView: View {
    let onContinue: () -> Void
    
    @State private var selectedSymbol: String = "pawprint.fill"
    @State private var selectedColor: Color = .blue
    @State private var selectedMotto: String = "Together We Rise"
    
    let symbols = ["pawprint.fill", "hare.fill", "bird.fill", "flame.fill", "bolt.fill", "leaf.fill"]
    let colors: [Color] = [.blue, .green, .red, .purple, .orange, .pink]
    let mottos = [
        "Together We Rise",
        "No Excuses",
        "Stay Accountable",
        "Push Forward",
        "Never Quit",
        "One Team"
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Header
            VStack(spacing: 16) {
                Text("PACK IDENTITY")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Every great crew has an identity. Choose yours.")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .padding(.bottom, 40)
            
            // Symbol Selection
            VStack(alignment: .leading, spacing: 16) {
                Text("SYMBOL")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(symbols, id: \.self) { symbol in
                            Button {
                                selectedSymbol = symbol
                            } label: {
                                Image(systemName: symbol)
                                    .font(.system(size: 32))
                                    .foregroundColor(.primary)
                                    .frame(width: 70, height: 70)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(selectedSymbol == symbol ? Color.blue.opacity(0.2) : Color.clear)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(selectedSymbol == symbol ? Color.blue : Color.primary.opacity(0.2), lineWidth: 2)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding(.bottom, 32)
            
            // Color Selection
            VStack(alignment: .leading, spacing: 16) {
                Text("COLOR")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
                
                HStack(spacing: 12) {
                    ForEach(colors, id: \.self) { color in
                        Button {
                            selectedColor = color
                        } label: {
                            Circle()
                                .fill(color)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Circle()
                                        .stroke(selectedColor == color ? Color.primary : Color.clear, lineWidth: 3)
                                )
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 32)
            
            // Motto Selection
            VStack(alignment: .leading, spacing: 16) {
                Text("MOTTO")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
                
                VStack(spacing: 8) {
                    ForEach(mottos, id: \.self) { motto in
                        Button {
                            selectedMotto = motto
                        } label: {
                            HStack {
                                Text(motto)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.primary)
                                Spacer()
                                if selectedMotto == motto {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedMotto == motto ? Color.blue.opacity(0.1) : Color.primary.opacity(0.05))
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            
            Spacer()
            
            // Continue Button
            Button(action: onContinue) {
                Text("CONTINUE")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .glassEffect(in: .rect(cornerRadius: 30))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground))
    }
}

#Preview {
    PackIdentityView(onContinue: {})
}
