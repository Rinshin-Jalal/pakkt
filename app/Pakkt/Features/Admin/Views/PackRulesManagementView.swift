import SwiftUI

struct PackRulesManagementView: View {
    @Environment(\.dismiss) var dismiss
    @State private var jailDuration: Int = 60
    @State private var votingDuration: Int = 24
    @State private var guiltyThreshold: Int = 51
    @State private var showSaveConfirmation = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("PACK RULES")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("Configure consequences and voting for your pack")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    
                    // Jail Settings
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.orange)
                            
                            Text("JAIL SETTINGS")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primary)
                        }
                        
                        Divider()
                            .background(Color.secondary.opacity(0.3))
                        
                        // Jail Duration
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Jail Duration")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            HStack {
                                Button(action: {
                                    if jailDuration > 15 {
                                        jailDuration -= 15
                                    }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.system(size: 32))
                                        .foregroundColor(.primary)
                                }
                                
                                Spacer()
                                
                                VStack(spacing: 4) {
                                    Text("\(jailDuration)")
                                        .font(.system(size: 40, weight: .bold))
                                        .foregroundColor(.primary)
                                    
                                    Text("MINUTES")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    if jailDuration < 240 {
                                        jailDuration += 15
                                    }
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 32))
                                        .foregroundColor(.primary)
                                }
                            }
                            .padding(.vertical, 8)
                            
                            Text("How long members will be jailed for failed check-ins")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(20)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .padding(.horizontal, 24)
                    
                    // Voting Settings
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "hand.raised.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                            
                            Text("VOTING SETTINGS")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primary)
                        }
                        
                        Divider()
                            .background(Color.secondary.opacity(0.3))
                        
                        // Voting Duration
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Voting Window")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            HStack {
                                Button(action: {
                                    if votingDuration > 6 {
                                        votingDuration -= 6
                                    }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.system(size: 32))
                                        .foregroundColor(.primary)
                                }
                                
                                Spacer()
                                
                                VStack(spacing: 4) {
                                    Text("\(votingDuration)")
                                        .font(.system(size: 40, weight: .bold))
                                        .foregroundColor(.primary)
                                    
                                    Text("HOURS")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    if votingDuration < 48 {
                                        votingDuration += 6
                                    }
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 32))
                                        .foregroundColor(.primary)
                                }
                            }
                            .padding(.vertical, 8)
                            
                            Text("How long pack members can vote on failed check-ins")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                        
                        Divider()
                            .background(Color.secondary.opacity(0.3))
                        
                        // Guilty Threshold
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Guilty Threshold")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            HStack {
                                Button(action: {
                                    if guiltyThreshold > 20 {
                                        guiltyThreshold -= 5
                                    }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.system(size: 32))
                                        .foregroundColor(.primary)
                                }
                                
                                Spacer()
                                
                                VStack(spacing: 4) {
                                    Text("\(guiltyThreshold)%")
                                        .font(.system(size: 40, weight: .bold))
                                        .foregroundColor(.primary)
                                    
                                    Text("REQUIRED")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    if guiltyThreshold < 100 {
                                        guiltyThreshold += 5
                                    }
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 32))
                                        .foregroundColor(.primary)
                                }
                            }
                            .padding(.vertical, 8)
                            
                            Text("Percentage of 'Guilty' votes needed to activate jail")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(20)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .padding(.horizontal, 24)
                    
                    // Info Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.blue)
                            
                            Text("RULE CHANGES")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.primary)
                        }
                        
                        Text("Changes to pack rules take effect immediately and apply to all future check-ins. Active votes and jails are not affected.")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(16)
                    .glassEffect(.regular.tint(.blue.opacity(0.05)), in: .rect(cornerRadius: 20))
                    .padding(.horizontal, 24)
                    
                    Spacer().frame(height: 100)
                }
                .padding(.top, 16)
                .padding(.bottom, 80)
            }
            
            // Bottom Button
            VStack {
                Spacer()
                
                Button(action: {
                    showSaveConfirmation = true
                    // Save logic here
                }) {
                    Text("SAVE CHANGES")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                }
                .buttonStyle(.glass)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("Pack Rules")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                }
            }
        }
        .alert("Rules Updated", isPresented: $showSaveConfirmation) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("Pack rules have been successfully updated.")
        }
    }
}

#Preview {
    NavigationStack {
        PackRulesManagementView()
    }
}
