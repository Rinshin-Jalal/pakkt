import SwiftUI

struct PackRulesManagementView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = PackAdminViewModel()
    @State private var jailDuration: Int = 60
    @State private var votingDuration: Int = 24
    @State private var guiltyThreshold: Int = 51
    @State private var showSaveConfirmation = false
    @State private var showCreateInviteCode = false
    @State private var showMemberRemoveConfirm = false
    @State private var memberToRemove: PackMember?
    @State private var selectedCodeToCopy: PackInviteCode?
    
    let packId: UUID
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("PACK ADMIN")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.primary)
                        
                        if let pack = viewModel.pack {
                            Text(pack.name)
                                .font(.system(size: 16))
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    
                    // Members Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "person.3.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                            
                            Text("MEMBERS (\(viewModel.members.count))")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primary)
                        }
                        
                        Divider()
                            .background(Color.secondary.opacity(0.3))
                        
                        if viewModel.isLoading && viewModel.members.isEmpty {
                            ProgressView()
                                .padding()
                        } else if viewModel.members.isEmpty {
                            Text("No members yet")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                                .padding()
                        } else {
                            ForEach(viewModel.members) { member in
                                MemberRow(member: member) {
                                    memberToRemove = member
                                    showMemberRemoveConfirm = true
                                }
                            }
                        }
                    }
                    .padding(20)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .padding(.horizontal, 24)
                    
                    // Invite Codes Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "envelope.badge.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.green)
                            
                            Text("INVITE CODES")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Button(action: {
                                showCreateInviteCode = true
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.green)
                            }
                        }
                        
                        Divider()
                            .background(Color.secondary.opacity(0.3))
                        
                        if viewModel.inviteCodes.isEmpty {
                            Text("No active invite codes")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                                .padding()
                        } else {
                            ForEach(viewModel.inviteCodes) { code in
                                InviteCodeRow(code: code,
                                    onCopy: {
                                        selectedCodeToCopy = code
                                        UIPasteboard.general.string = code.code
                                    },
                                    onDeactivate: {
                                        Task {
                                            await viewModel.deactivateInviteCode(code.id)
                                        }
                                    }
                                )
                            }
                        }
                    }
                    .padding(20)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .padding(.horizontal, 24)
                    
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
        .navigationTitle("Pack Admin")
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
        .task {
            viewModel.packId = packId
            await viewModel.loadPackData()
        }
        .sheet(isPresented: $showCreateInviteCode) {
            CreateInviteCodeSheet(viewModel: viewModel)
        }
        .alert("Remove Member", isPresented: $showMemberRemoveConfirm) {
            Button("Cancel", role: .cancel) { }
            Button("Remove", role: .destructive) {
                if let member = memberToRemove {
                    Task {
                        let success = await viewModel.removeMember(member.userId)
                        if success {
                            memberToRemove = nil
                        }
                    }
                }
            }
        } message: {
            if let member = memberToRemove {
                Text("Are you sure you want to remove \(member.username) from the pack? This action cannot be undone.")
            }
        }
        .alert("Copied!", isPresented: .constant(selectedCodeToCopy != nil)) {
            Button("OK") {
                selectedCodeToCopy = nil
            }
        } message: {
            Text("Invite code copied to clipboard")
        }
        .alert("Rules Updated", isPresented: $showSaveConfirmation) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("Pack rules have been successfully updated.")
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.clearError()
            }
        } message: {
            if let error = viewModel.errorMessage {
                Text(error)
            }
        }
    }
}

// MARK: - Member Row
struct MemberRow: View {
    let member: PackMember
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [.blue, .purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: 40, height: 40)
                .overlay(
                    Text(member.username.prefix(2).uppercased())
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(member.username)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                
                if member.isAdmin {
                    Text("Admin")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.blue)
                }
            }
            
            Spacer()
            
            if !member.isAdmin {
                Button(action: onRemove) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Invite Code Row
struct InviteCodeRow: View {
    let code: PackInviteCode
    let onCopy: () -> Void
    let onDeactivate: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(code.code)
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: onCopy) {
                    Image(systemName: "doc.on.doc.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.blue)
                }
                
                if code.isActive {
                    Button(action: onDeactivate) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.red)
                    }
                }
            }
            
            HStack(spacing: 12) {
                Label("\(code.currentUses)/\(code.maxUses) uses", systemImage: "person.2.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                
                Label(code.isActive ? "Active" : "Inactive", systemImage: code.isActive ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.system(size: 12))
                    .foregroundColor(code.isActive ? .green : .red)
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Create Invite Code Sheet
struct CreateInviteCodeSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: PackAdminViewModel
    @State private var maxUses: Int = 10
    @State private var expiresInHours: Int = 24
    @State private var createdCode: PackInviteCode?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground).ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Max Uses
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Maximum Uses")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        HStack {
                            Button(action: { if maxUses > 1 { maxUses -= 1 } }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(.primary)
                            }
                            
                            Spacer()
                            
                            Text("\(maxUses)")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Button(action: { if maxUses < 100 { maxUses += 1 } }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .padding(20)
                    .glassEffect(in: .rect(cornerRadius: 20))
                    
                    // Expires In
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Expires In (Hours)")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        HStack {
                            Button(action: { if expiresInHours > 1 { expiresInHours -= 1 } }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(.primary)
                            }
                            
                            Spacer()
                            
                            Text("\(expiresInHours)")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Button(action: { if expiresInHours < 168 { expiresInHours += 1 } }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .padding(20)
                    .glassEffect(in: .rect(cornerRadius: 20))
                    
                    if let code = createdCode {
                        VStack(spacing: 12) {
                            Text("Invite Code Created!")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.green)
                            
                            Text(code.code)
                                .font(.system(size: 24, weight: .bold, design: .monospaced))
                                .foregroundColor(.primary)
                                .padding()
                                .glassEffect(in: .rect(cornerRadius: 12))
                            
                            Button(action: {
                                UIPasteboard.general.string = code.code
                            }) {
                                HStack {
                                    Image(systemName: "doc.on.doc.fill")
                                    Text("Copy Code")
                                }
                                .font(.system(size: 16, weight: .semibold))
                            }
                        }
                        .padding(20)
                    }
                    
                    Spacer()
                    
                    if createdCode == nil {
                        Button(action: {
                            Task {
                                if let code = await viewModel.createInviteCode(maxUses: maxUses, expiresInHours: expiresInHours) {
                                    createdCode = code
                                }
                            }
                        }) {
                            Text("CREATE CODE")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                        }
                        .buttonStyle(.glass)
                        .disabled(viewModel.isLoading)
                    } else {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("DONE")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                        }
                        .buttonStyle(.glass)
                    }
                }
                .padding(24)
            }
            .navigationTitle("Create Invite Code")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PackRulesManagementView(packId: UUID())
    }
}
