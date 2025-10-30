import SwiftUI

struct PackPreviewView: View {
    let onContinue: () -> Void
    
    var body: some View {
        ScrollView() {
            Spacer()
            
            // Header
            VStack(spacing: 16) {
                Text("PACK PREVIEW")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("This is your accountability crew. Ready to make it official?")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .padding(.bottom, 40)
            
          
                VStack(spacing: 20) {
                    // Pack Identity
                    VStack(spacing: 12) {
                        Image(systemName: "pawprint.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.primary)
                        Text("THE LIONS")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primary)
                        Text("Together We Rise")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .glassEffect(in: .rect(cornerRadius: 30))

                    // Goals
                    VStack(alignment: .leading, spacing: 12) {
                        Text("GOALS")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)
                        Text("Morning workout at 6 AM")
                            .font(.system(size: 16))
                            .foregroundColor(.primary)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    
                    // Consequences
                    VStack(alignment: .leading, spacing: 12) {
                        Text("CONSEQUENCES")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("•")
                                Text("1 strike: 30 min jail")
                            }
                            HStack {
                                Text("•")
                                Text("2 strikes: 1 hr jail")
                            }
                            HStack {
                                Text("•")
                                Text("3 strikes: Kicked from pack")
                            }
                        }
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    
                    // Rules
                    VStack(alignment: .leading, spacing: 12) {
                        Text("RULES")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("•")
                                Text("Check in within 30 min window")
                            }
                            HStack {
                                Text("•")
                                Text("Photo proof required")
                            }
                            HStack {
                                Text("•")
                                Text("No excuses policy")
                            }
                        }
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glassEffect(in: .rect(cornerRadius: 30))
                }
                .padding(.horizontal, 20)
            
            Spacer()
            Spacer()
            Spacer()


            // Continue Button
            Button(action: onContinue) {
                Text("LOOKS GOOD")
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
    PackPreviewView(onContinue: {})
}
