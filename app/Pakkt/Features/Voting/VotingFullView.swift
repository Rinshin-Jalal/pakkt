import SwiftUI

struct VotingFullView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedVote: VoteOption? = nil
    @State private var votingState: VotingState = .active
    @State private var showGavel = false
    @State private var showVerdict = false
    @State private var showConsequence = false
    
    // Mock data for active voting
    let checkIn = MockVotingCheckIn(
        userName: "Sarah Chen",
        userInitials: "SC",
        packName: "Morning Warriors",
        goalText: "5km morning run",
        missedReason: "Overslept - alarm didn't go off",
        timeAgo: "30m ago",
        votingData: VotingData(
            dontFineVotes: 2,
            fineVotes: 1,
            waitVotes: 1,
            totalMembers: 8,
            hoursLeft: 2,
            hasVoted: false,
            userVote: nil
        ),
        members: [
            VotingMember(name: "John Smith", initials: "JS", vote: .dontFine),
            VotingMember(name: "Emma Wilson", initials: "EW", vote: .fine),
            VotingMember(name: "Mike Johnson", initials: "MJ", vote: .wait),
            VotingMember(name: "Lisa Anderson", initials: "LA", vote: .dontFine),
            VotingMember(name: "You", initials: "ME", vote: nil),
            VotingMember(name: "Tom Brown", initials: "TB", vote: nil),
            VotingMember(name: "Amy Davis", initials: "AD", vote: nil),
            VotingMember(name: "Chris Lee", initials: "CL", vote: nil)
        ]
    )
    
    // Mock data for results
    let result = VotingResult(
        userName: "Sarah Chen",
        userInitials: "SC",
        packName: "Morning Warriors",
        goalText: "5km morning run",
        missedReason: "Overslept - alarm didn't go off",
        verdict: .guilty,
        consequence: "1 hour jail",
        finalVotes: FinalVotes(
            forgive: 3,
            jail: 5,
            wait: 0
        ),
        members: [
            VotingMember(name: "John Smith", initials: "JS", vote: .dontFine),
            VotingMember(name: "Emma Wilson", initials: "EW", vote: .fine),
            VotingMember(name: "Mike Johnson", initials: "MJ", vote: .fine),
            VotingMember(name: "Lisa Anderson", initials: "LA", vote: .dontFine),
            VotingMember(name: "You", initials: "ME", vote: .fine),
            VotingMember(name: "Tom Brown", initials: "TB", vote: .fine),
            VotingMember(name: "Amy Davis", initials: "AD", vote: .dontFine),
            VotingMember(name: "Chris Lee", initials: "CL", vote: .fine)
        ]
    )
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                                .frame(width: 36, height: 36)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        
                        // Timer (only show in active state)
                        if votingState == .active {
                            HStack(spacing: 6) {
                                Image(systemName: "clock.fill")
                                    .font(.system(size: 12))
                                Text("\(checkIn.votingData.hoursLeft)h left")
                                    .font(.system(size: 13, weight: .semibold))
                            }
                            .foregroundColor(.primary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Title or Verdict
                    if votingState == .active {
                        Text("PACK VOTING")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                            .padding(.top, 8)
                    } else {
                        // Gavel Animation & Verdict
                        VStack(spacing: 20) {
                            if showGavel {
                                Image(systemName: "hammer.fill")
                                    .font(.system(size: 64))
                                    .foregroundColor(result.verdict == .guilty ? Color(hex: "#FF3B30") : Color(hex: "#00D448"))
                                    .rotationEffect(.degrees(showVerdict ? 0 : -45))
                                    .scaleEffect(showVerdict ? 1 : 0.5)
                                    .animation(.spring(response: 0.5, dampingFraction: 0.6), value: showVerdict)
                            }
                            
                            if showVerdict {
                                VStack(spacing: 8) {
                                    Text(result.verdict == .guilty ? "GUILTY" : "INNOCENT")
                                        .font(.system(size: 36, weight: .black))
                                        .foregroundColor(result.verdict == .guilty ? Color(hex: "#FF3B30") : Color(hex: "#00D448"))
                                    
                                    Text("The pack has decided")
                                        .font(.system(size: 14))
                                        .foregroundColor(.secondary)
                                }
                                .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .frame(height: 180)
                    }
                    
                    // Check-In Info Card
                    VStack(spacing: 16) {
                        HStack(spacing: 12) {
                            // Avatar
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 56, height: 56)
                                .overlay(
                                    Text(checkIn.userInitials)
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.primary)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(checkIn.userName)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                Text(checkIn.packName)
                                    .font(.system(size: 13))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        
                        Divider()
                            .background(.secondary.opacity(0.2))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Missed Goal")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                                .textCase(.uppercase)
                            
                            Text(checkIn.goalText)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            if let reason = checkIn.missedReason {
                                Text(reason)
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                                    .padding(.top, 4)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(20)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .padding(.horizontal, 20)
                    
                    // Active Voting UI
                    if votingState == .active {
                        activeVotingContent
                    }
                    
                    // Results UI
                    if votingState == .completed {
                        resultsContent
                    }
                }
            }
        }
        .onAppear {
            if votingState == .completed {
                animateResults()
            }
        }
    }
    
    // MARK: - Active Voting Content
    
    private var activeVotingContent: some View {
        Group {
            // Voting Progress
            VStack(spacing: 16) {
                Text("Should \(checkIn.userName) be jailed?")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Vote Bar
                VStack(spacing: 12) {
                    GeometryReader { geometry in
                        HStack(spacing: 2) {
                            RoundedRectangle(cornerRadius: selectedVote != nil ? 12 : 8)
                                .fill(Color(hex: "#00D448"))
                                .frame(width: geometry.size.width * (Double(checkIn.votingData.dontFineVotes) / Double(checkIn.votingData.totalMembers)))
                            
                            RoundedRectangle(cornerRadius: selectedVote != nil ? 12 : 8)
                                .fill(Color(hex: "#FF3B30"))
                                .frame(width: geometry.size.width * (Double(checkIn.votingData.fineVotes) / Double(checkIn.votingData.totalMembers)))
                            
                            RoundedRectangle(cornerRadius: selectedVote != nil ? 12 : 8)
                                .fill(Color(hex: "#FF9500"))
                                .frame(width: geometry.size.width * (Double(checkIn.votingData.waitVotes) / Double(checkIn.votingData.totalMembers)))
                            
                            RoundedRectangle(cornerRadius: selectedVote != nil ? 12 : 8)
                                .fill(.secondary.opacity(0.2))
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(height: selectedVote != nil ? 40 : 20)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedVote)
                    
                    // Legend
                    HStack(spacing: 16) {
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color(hex: "#00D448"))
                                .frame(width: 8, height: 8)
                            Text("Forgive (\(checkIn.votingData.dontFineVotes))")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                        
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color(hex: "#FF3B30"))
                                .frame(width: 8, height: 8)
                            Text("Jail (\(checkIn.votingData.fineVotes))")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                        
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color(hex: "#FF9500"))
                                .frame(width: 8, height: 8)
                            Text("Wait (\(checkIn.votingData.waitVotes))")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    
                    Text("\(votedCount)/\(checkIn.votingData.totalMembers) pack members voted")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary.opacity(0.8))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(20)
            .glassEffect(in: .rect(cornerRadius: 30))
            .padding(.horizontal, 20)
            
            // Members Grid
            VStack(spacing: 16) {
                Text("Pack Members")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(checkIn.members) { member in
                        MemberVoteCard(member: member)
                    }
                }
            }
            .padding(20)
            .glassEffect(in: .rect(cornerRadius: 30))
            .padding(.horizontal, 20)
            
            // Voting Buttons
            if !checkIn.votingData.hasVoted {
                VStack(spacing: 12) {
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedVote = .dontFine
                        }
                    }) {
                        HStack {
                            Image(systemName: "hand.thumbsup.fill")
                                .font(.system(size: 16))
                            Text("Forgive")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                    }
                    .buttonStyle(.glass)
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedVote = .fine
                        }
                    }) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 16))
                            Text("Jail")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                    }
                    .buttonStyle(.glass)
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedVote = .wait
                        }
                    }) {
                        HStack {
                            Image(systemName: "clock.fill")
                                .font(.system(size: 16))
                            Text("Wait 30m")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                    }
                    .buttonStyle(.glass)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
    }
    
    // MARK: - Results Content
    
    private var resultsContent: some View {
        Group {
            // Final Votes
            if showConsequence {
                VStack(spacing: 16) {
                    Text("Final Vote")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 24) {
                        VoteCount(
                            label: "Forgive",
                            count: result.finalVotes.forgive,
                            color: Color(hex: "#00D448")
                        )
                        
                        VoteCount(
                            label: "Jail",
                            count: result.finalVotes.jail,
                            color: Color(hex: "#FF3B30")
                        )
                        
                        if result.finalVotes.wait > 0 {
                            VoteCount(
                                label: "Wait",
                                count: result.finalVotes.wait,
                                color: Color(hex: "#FF9500")
                            )
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(20)
                .glassEffect(in: .rect(cornerRadius: 30))
                .padding(.horizontal, 20)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            // Consequence
            if showConsequence && result.verdict == .guilty {
                VStack(spacing: 12) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color(hex: "#FF3B30"))
                    
                    Text("CONSEQUENCE")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                    
                    Text(result.consequence)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .glassEffect(in: .rect(cornerRadius: 30))
                .padding(.horizontal, 20)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            // Members Grid
            if showConsequence {
                VStack(spacing: 16) {
                    Text("How Everyone Voted")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(result.members) { member in
                            MemberVoteCard(member: member)
                        }
                    }
                }
                .padding(20)
                .glassEffect(in: .rect(cornerRadius: 30))
                .padding(.horizontal, 20)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            // Done Button
            if showConsequence {
                Button(action: { dismiss() }) {
                    Text("Done")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .buttonStyle(.glass)
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private var votedCount: Int {
        checkIn.votingData.dontFineVotes + checkIn.votingData.fineVotes + checkIn.votingData.waitVotes
    }
    
    private func animateResults() {
        withAnimation(.easeOut(duration: 0.3)) {
            showGavel = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                showVerdict = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                showConsequence = true
            }
        }
    }
}

struct VoteCount: View {
    let label: String
    let count: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text("\(count)")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(color)
            
            Text(label)
                .font(.system(size: 13))
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Supporting Views

struct MemberVoteCard: View {
    let member: VotingMember
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 40, height: 40)
                .overlay(
                    Text(member.initials)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.primary)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(member.name)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                if let vote = member.vote {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(voteColor(for: vote))
                            .frame(width: 6, height: 6)
                        Text(voteText(for: vote))
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }
                } else {
                    Text("Not voted")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary.opacity(0.6))
                }
            }
            
            Spacer()
        }
        .padding(12)
        .background(.ultraThinMaterial.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func voteText(for vote: VoteOption) -> String {
        switch vote {
        case .dontFine: return "Forgive"
        case .fine: return "Jail"
        case .wait: return "Wait"
        }
    }
    
    private func voteColor(for vote: VoteOption) -> Color {
        switch vote {
        case .dontFine: return Color(hex: "#00D448")
        case .fine: return Color(hex: "#FF3B30")
        case .wait: return Color(hex: "#FF9500")
        }
    }
}

// MARK: - Data Models

struct MockVotingCheckIn {
    let userName: String
    let userInitials: String
    let packName: String
    let goalText: String
    let missedReason: String?
    let timeAgo: String
    let votingData: VotingData
    let members: [VotingMember]
}

struct VotingResult {
    let userName: String
    let userInitials: String
    let packName: String
    let goalText: String
    let missedReason: String?
    let verdict: Verdict
    let consequence: String
    let finalVotes: FinalVotes
    let members: [VotingMember]
}

#Preview {
    VotingFullView()
}
