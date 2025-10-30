import SwiftUI

struct PackConsequencesView: View {
    let onContinue: () -> Void
    
    @State private var cashFine: Double = 5
    @State private var jailTime: Double = 30
    @State private var requireVote = true
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 12) {
                    Text("SET CONSEQUENCES")
                        .font(.system(size: 28, weight: .bold))
                        .tracking(2)
                        .foregroundColor(.primary)

                    Text("for missing your goals")
                        .font(.system(size: 17))
                        .foregroundColor(.secondary)
                }
                .padding(.top, 60)
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Consequence options
                VStack(spacing: 20) {
                    // Jail time
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "iphone.slash")
                                .font(.system(size: 24))
                                .foregroundColor(.primary)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("PHONE JAIL")
                                    .font(.system(size: 15, weight: .semibold))
                                    .tracking(1)
                                    .foregroundColor(.primary)
                                
                                Text("Apps locked when you miss")
                                    .font(.system(size: 13))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Text("\(Int(jailTime))min")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.primary)
                        }
                        
                        Slider(value: $jailTime, in: 15...60, step: 15)
                            .tint(.primary.opacity(0.8))
                    }
                    .padding(20)
                    .glassEffect(in: .rect(cornerRadius: 30))

                    // Voting
                    HStack {
                        Image(systemName: requireVote ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 24))
                            .foregroundColor(.primary)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("MAJORITY VOTE REQUIRED")
                                .font(.system(size: 15, weight: .semibold))
                                .tracking(1)
                                .foregroundColor(.primary)
                            
                            Text("Pack decides if excuse is valid")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(20)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3)) {
                            requireVote.toggle()
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Continue button
                Button(action: onContinue) {
                    HStack {
                        Text("SET CONSEQUENCES")
                            .font(.system(size: 17, weight: .semibold))
                            .tracking(1)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                }
                .buttonStyle(.glass)
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    PackConsequencesView(onContinue: {})
}
