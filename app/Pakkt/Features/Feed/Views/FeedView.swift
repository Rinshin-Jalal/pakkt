import SwiftUI

struct FeedView: View {
    @State private var showCreateCheckIn = false
    
    // Helper functions to filter check-ins by date
    private func isToday(_ checkIn: MockCheckIn) -> Bool {
        checkIn.timeAgo.contains("ago") || checkIn.timeAgo.contains("Due in")
    }
    
    private func isYesterday(_ checkIn: MockCheckIn) -> Bool {
        checkIn.timeAgo == "Yesterday"
    }
    
    private func isEarlierThisWeek(_ checkIn: MockCheckIn) -> Bool {
        checkIn.timeAgo.contains("days ago")
    }
    
    // All cards now use message-style alignment (left/right based on user)

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Background with native dark mode support
            Color(.systemBackground)
                .ignoresSafeArea()
                .background(.ultraThinMaterial)
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 20) {
                        // Earlier This Week (OLDEST - at top)
                        DateDivider(text: "Earlier this week")

                        ForEach(mockCheckIns.filter { isEarlierThisWeek($0) }) { checkIn in
                            CheckInActivityCard(checkIn: checkIn)
                                .padding(.horizontal, checkIn.isCurrentUser ? 0 : 16)
                                .padding(.trailing, checkIn.isCurrentUser ? 16 : 0)
                                .padding(.leading, checkIn.isCurrentUser ? 16 : 0)
                        }

                        Spacer().frame(height: 10)

                        // Yesterday Section
                        DateDivider(text: "Yesterday")

                        ForEach(mockCheckIns.filter { isYesterday($0) }) { checkIn in
                            CheckInActivityCard(checkIn: checkIn)
                                .padding(.horizontal, checkIn.isCurrentUser ? 0 : 16)
                                .padding(.trailing, checkIn.isCurrentUser ? 16 : 0)
                                .padding(.leading, checkIn.isCurrentUser ? 16 : 0)
                        }

                        Spacer().frame(height: 20)

                        // Today Section (NEWEST - at bottom)
                        DateDivider(text: "Today")

                        ForEach(mockCheckIns.filter { isToday($0) }) { checkIn in
                            CheckInActivityCard(checkIn: checkIn)
                                .padding(.horizontal, checkIn.isCurrentUser ? 0 : 16)
                                .padding(.trailing, checkIn.isCurrentUser ? 16 : 0)
                                .padding(.leading, checkIn.isCurrentUser ? 16 : 0)
                        }

                        // Bottom anchor
                        Color.clear
                            .frame(height: 1)
                            .id("bottom")
                    }
                    .padding(.top, 8)      // Reduced from 16
                    .padding(.bottom, 80)   // Reduced from 120
                }
                .onAppear {
                    proxy.scrollTo("bottom", anchor: .bottom)
                }
            }
            .navigationTitle("My Pack")
            .navigationBarTitleDisplayMode(.large)

            // Primary Action - Liquid Glass Style (72x72pt for big thumbs)
            Button(action: { showCreateCheckIn = true }) {
                Image(systemName: "camera.fill")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 72, height: 72)
            }
            .buttonStyle(.glass)
            .padding(24)
        }
        .sheet(isPresented: $showCreateCheckIn) {
            CreateCheckInView()
        }
    }
}

// MARK: - Date Divider Component
struct DateDivider: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
    }
}

// MARK: - Next Goal Reminder Card - ACTUAL Liquid Glass
struct NextGoalCard: View {
    var body: some View {
        HStack(spacing: 16) {
            // Timer
            VStack(spacing: 4) {
                Text("2:34")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.orange)

                Text("LEFT")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            .frame(width: 80, height: 80)

            // Goal info
            VStack(alignment: .leading, spacing: 8) {
                Text("🏋️ Gym session")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)

                Text("Due by 6:00 PM")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)

                Text("Check in now")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.orange)
            }

            Spacer()
        }
        .padding(20)
        .glassEffect(in: .rect(cornerRadius: 20))
    }
}

// MARK: - Unified Check-In Activity Card
struct CheckInActivityCard: View {
    let checkIn: MockCheckIn
    @State private var selectedVote: VoteOption? = nil
    
    var body: some View {
        switch checkIn.status {
        case .success:
            SuccessCard(checkIn: checkIn)
        case .late(let minutesLate):
            LateCard(checkIn: checkIn, minutesLate: minutesLate)
        case .pending(let minutesLeft):
            PendingCard(checkIn: checkIn, minutesLeft: minutesLeft)
        case .failedVoting(let votingData):
            VotingCard(checkIn: checkIn, votingData: votingData, selectedVote: $selectedVote)
        case .fineActivated(let voteResults):
            FineActivatedCard(checkIn: checkIn, voteResults: voteResults)
        case .forgiven(let voteResults):
            ForgivenCard(checkIn: checkIn, voteResults: voteResults)
        }
    }
}

// MARK: - Success Card (Original CheckInCard)
struct SuccessCard: View {
    let checkIn: MockCheckIn
    
    private var accentColor: Color {
        if checkIn.streak > 5 {
            return Color(hex: "#0066FF")
        } else {
            return Color.white.opacity(0.15)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                if checkIn.isCurrentUser {
                    Spacer()
                    
                    // Success badge
                    StatusBadge(icon: "checkmark.circle.fill", color: Color(hex: "#00D448"))
                    
                    Text(checkIn.timeAgo)
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    Text(checkIn.userName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                } else {
                    Text(checkIn.userName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    Text(checkIn.timeAgo)
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    
                    // Success badge
                    StatusBadge(icon: "checkmark.circle.fill", color: Color(hex: "#00D448"))
                    
                    Spacer()
                }
            }
            
            HStack {
                if checkIn.isCurrentUser { Spacer(minLength: 50) }
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(checkIn.goalText)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 0)
                            .padding(.top, 16)
                            .padding(.bottom, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if let message = checkIn.message {
                            Text(message)
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        
                        ZStack(alignment: .topLeading) {
                            if let imageURL = checkIn.proofImage {
                                GeometryReader { geo in
                                    AsyncImage(url: URL(string: imageURL)) { phase in
                                        switch phase {
                                        case .empty:
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.black.opacity(0.4))
                                                .overlay(ProgressView().tint(.white))
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: geo.size.width, height: geo.size.height)
                                                .clipped()
                                        case .failure:
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.black.opacity(0.4))
                                                .overlay(
                                                    Image(systemName: "photo.fill")
                                                        .font(.system(size: 40))
                                                        .foregroundColor(.white.opacity(0.3))
                                                )
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                }
                                .aspectRatio(4/3, contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            
                            VStack(spacing: 0) {
                                Spacer()
                                
                                HStack(spacing: 16) {
                                    HStack(spacing: 6) {
                                        Text("+\(checkIn.xpEarned)")
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundColor(.primary)
                                        Text("xp")
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .glassEffect(.regular.tint(.green.opacity(0.1)), in: .capsule)
                                    
                                    Spacer()
                                    
                                    Button(action: {}) {
                                        HStack(spacing: 6) {
                                            Image(systemName: checkIn.isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                                                .font(.system(size: 16))
                                                .foregroundColor(.white)
                                            Text("\(checkIn.likeCount)")
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(.white)
                                        }
                                    }.buttonStyle(.glass)
                                    
                                    Button(action: {}) {
                                        HStack(spacing: 6) {
                                            Image(systemName: "message.fill")
                                                .font(.system(size: 16))
                                                .foregroundColor(.white)
                                            Text("\(checkIn.commentCount)")
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(.white)
                                        }
                                    }.buttonStyle(.glass)
                                }
                                .padding(10)
                            }
                            .padding(0)
                        }
                        .frame(height: checkIn.proofImage != nil ? nil : 60)
                    }
                    .padding(16)
                    .glassEffect(in: .rect(cornerRadius: 30))
                }
                if !checkIn.isCurrentUser { Spacer(minLength: 40) }
            }
        }
    }
}

// MARK: - Late Card
struct LateCard: View {
    let checkIn: MockCheckIn
    let minutesLate: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                if checkIn.isCurrentUser {
                    Spacer()
                    
                    // Late badge
                    StatusBadge(icon: "clock.fill", color: Color(hex: "#FF9500"))
                    
                    Text(checkIn.timeAgo)
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    Text(checkIn.userName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                } else {
                    Text(checkIn.userName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    Text(checkIn.timeAgo)
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    
                    // Late badge
                    StatusBadge(icon: "clock.fill", color: Color(hex: "#FF9500"))
                    
                    Spacer()
                }
            }
            
            HStack {
                if checkIn.isCurrentUser { Spacer(minLength: 50) }
                VStack(alignment: .leading, spacing: 0) {
                    // Yellow warning banner
                    HStack {
                        Text("⏰ Checked in \(minutesLate)m late")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        Text("-\(100 - checkIn.xpEarned)xp")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color(hex: "#FF9500").opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(checkIn.goalText)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.top, 16)
                        
                        if let message = checkIn.message {
                            Text(message)
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        
                        ActionButtons(checkIn: checkIn)
                    }
                    .padding(16)
                }
                .glassEffect(in: .rect(cornerRadius: 30))
                if !checkIn.isCurrentUser { Spacer(minLength: 40) }
            }
        }
    }
}

// MARK: - Pending Card
struct PendingCard: View {
    let checkIn: MockCheckIn
    let minutesLeft: Int
    
    private var timeString: String {
        let hours = minutesLeft / 60
        let mins = minutesLeft % 60
        return "\(hours):\(String(format: "%02d", mins))"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                if checkIn.isCurrentUser {
                    Spacer()
                    
                    // Pending badge
                    StatusBadge(icon: "hourglass", color: Color(hex: "#007AFF"))
                    
                    Text(checkIn.timeAgo)
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    Text(checkIn.userName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                } else {
                    Text(checkIn.userName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    Text(checkIn.timeAgo)
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    
                    // Pending badge
                    StatusBadge(icon: "hourglass", color: Color(hex: "#007AFF"))
                    
                    Spacer()
                }
            }
            
            HStack(spacing: 16) {
                VStack(spacing: 4) {
                    Text(timeString)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.orange)
                    
                    Text("LEFT")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.secondary)
                }
                .frame(width: 80, height: 80)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(checkIn.goalText)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("Due by 6:00 PM")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                    
                    Text("Check in now")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.orange)
                }
                
                Spacer()
            }
            .padding(20)
            .glassEffect(in: .rect(cornerRadius: 20))
        }
    }
}

// MARK: - Voting Card
struct VotingCard: View {
    let checkIn: MockCheckIn
    let votingData: VotingData
    @Binding var selectedVote: VoteOption?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                if checkIn.isCurrentUser {
                    Spacer()
                    
                    // Voting badge
                    StatusBadge(icon: "hand.raised.fill", color: Color(hex: "#FF9500"))
                    
                    Text(checkIn.timeAgo)
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    Text(checkIn.userName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                } else {
                    Text(checkIn.userName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    Text(checkIn.timeAgo)
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    
                    // Voting badge
                    StatusBadge(icon: "hand.raised.fill", color: Color(hex: "#FF9500"))
                    
                    Spacer()
                }
            }
            
            HStack {
                if checkIn.isCurrentUser { Spacer(minLength: 50) }
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(checkIn.goalText)
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        
                        Spacer()
                        
                        Text("\(votingData.hoursLeft)h left")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    HStack {
                        Text("Check-In Failed")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        Text("$5")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    
                    Divider().background(Color.white.opacity(0.2))
                    
                    VotingSection(
                        votingData: votingData,
                        userName: checkIn.userName,
                        selectedVote: $selectedVote,
                        canVote: !checkIn.isCurrentUser
                    )
                }
                .padding(20)
                .glassEffect(in: .rect(cornerRadius: 30))
                
                if !checkIn.isCurrentUser { Spacer(minLength: 40) }
            }
        }
    }
}

// MARK: - Fine Activated Card
struct FineActivatedCard: View {
    let checkIn: MockCheckIn
    let voteResults: VoteResults
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                if checkIn.isCurrentUser {
                    Spacer()
                    
                    // Fine badge
                    StatusBadge(icon: "exclamationmark.triangle.fill", color: Color(hex: "#FF3B30"))
                    
                    Text(checkIn.timeAgo)
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    Text(checkIn.userName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                } else {
                    Text(checkIn.userName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    Text(checkIn.timeAgo)
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    
                    // Fine badge
                    StatusBadge(icon: "exclamationmark.triangle.fill", color: Color(hex: "#FF3B30"))
                    
                    Spacer()
                }
            }
            
            HStack {
                if checkIn.isCurrentUser { Spacer(minLength: 50) }
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("⚠️ Fine Activated")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        Text("$\(voteResults.fineAmount)")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(checkIn.goalText)
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    Divider().background(Color.white.opacity(0.2))
                    
                    VoteResultsSection(
                        voteResults: voteResults,
                        message: "Pack voted to fine \(checkIn.isCurrentUser ? "you" : checkIn.userName)"
                    )
                }
                .padding(20)
                .glassEffect(in: .rect(cornerRadius: 20))
                
                if !checkIn.isCurrentUser { Spacer(minLength: 40) }
            }
        }
    }
}

// MARK: - Forgiven Card
struct ForgivenCard: View {
    let checkIn: MockCheckIn
    let voteResults: VoteResults
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                if checkIn.isCurrentUser {
                    Spacer()
                    
                    // Forgiven badge
                    StatusBadge(icon: "heart.fill", color: Color(hex: "#00D448"))
                    
                    Text(checkIn.timeAgo)
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    Text(checkIn.userName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                } else {
                    Text(checkIn.userName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    Text(checkIn.timeAgo)
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    
                    // Forgiven badge
                    StatusBadge(icon: "heart.fill", color: Color(hex: "#00D448"))
                    
                    Spacer()
                }
            }
            
            HStack {
                if checkIn.isCurrentUser { Spacer(minLength: 50) }
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("✅ Pack Forgave This Miss")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        Text("$0")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(Color(hex: "#00D448").opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(checkIn.goalText)
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    Divider().background(Color.white.opacity(0.2))
                    
                    VoteResultsSection(
                        voteResults: voteResults,
                        message: "Pack voted not to fine \(checkIn.isCurrentUser ? "you" : checkIn.userName)"
                    )
                }
                .padding(20)
                .glassEffect(in: .rect(cornerRadius: 20))
                
                if !checkIn.isCurrentUser { Spacer(minLength: 40) }
            }
        }
    }
}





struct UserHeader: View {
    let checkIn: MockCheckIn
    
    var body: some View {
        HStack(spacing: 8) {
            if checkIn.isCurrentUser {
                Spacer()
                Text(checkIn.timeAgo)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text(checkIn.userName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
            } else {
                Text(checkIn.userName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                Text(checkIn.timeAgo)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
    }
}

struct UserAvatar: View {
    let initials: String
    let color: Color
    
    var body: some View {
        Circle()
            .fill(color.opacity(0.2))
            .frame(width: 44, height: 44)
            .overlay(
                Text(initials)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(color)
            )
    }
}

struct ActionButtons: View {
    let checkIn: MockCheckIn
    
    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 6) {
                Text("+\(checkIn.xpEarned)")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.primary)
                Text("xp")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .glassEffect(.regular.tint(.green.opacity(0.1)), in: .capsule)
            
            Spacer()
            
            Button(action: {}) {
                HStack(spacing: 6) {
                    Image(systemName: checkIn.isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                    Text("\(checkIn.likeCount)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
            }.buttonStyle(.glass)
            
            Button(action: {}) {
                HStack(spacing: 6) {
                    Image(systemName: "message.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                    Text("\(checkIn.commentCount)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
            }.buttonStyle(.glass)
        }
        .padding(10)
    }
}

struct VotingSection: View {
    let votingData: VotingData
    let userName: String
    @Binding var selectedVote: VoteOption?
    let canVote: Bool
    
    private var votedCount: Int {
        votingData.dontFineVotes + votingData.fineVotes + votingData.waitVotes
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Should \(userName) be fined?")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))
            
            VStack(alignment: .leading, spacing: 8) {
                GeometryReader { geometry in
                    HStack(spacing: 2) {
                        RoundedRectangle(cornerRadius: selectedVote != nil ? 12 : 8)
                            .fill(Color(hex: "#00D448"))
                            .frame(width: geometry.size.width * (Double(votingData.dontFineVotes) / Double(votingData.totalMembers)))
                        
                        RoundedRectangle(cornerRadius: selectedVote != nil ? 12 : 8)
                            .fill(Color(hex: "#FF3B30"))
                            .frame(width: geometry.size.width * (Double(votingData.fineVotes) / Double(votingData.totalMembers)))
                        
                        RoundedRectangle(cornerRadius: selectedVote != nil ? 12 : 8)
                            .fill(Color(hex: "#FF9500"))
                            .frame(width: geometry.size.width * (Double(votingData.waitVotes) / Double(votingData.totalMembers)))
                        
                        RoundedRectangle(cornerRadius: selectedVote != nil ? 12 : 8)
                            .fill(Color.white.opacity(0.1))
                            .frame(maxWidth: .infinity)
                    }
                }
                .frame(height: selectedVote != nil ? 40 : 20)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedVote)
                
                VoteLegend()
                
                Text("\(votedCount)/\(votingData.totalMembers) pack members voted")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            if !canVote {
                Text("You can't vote on your own check-in")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.5))
                    .italic()
            } else if !votingData.hasVoted {
                VotingButtons(selectedVote: $selectedVote, votingData: votingData)
            } else {
                VoteConfirmation(vote: votingData.userVote)
            }
        }
    }
}

struct VoteLegend: View {
    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 6) {
                Circle()
                    .fill(Color(hex: "#00D448"))
                    .frame(width: 8, height: 8)
                Text("Don't Fine")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            HStack(spacing: 6) {
                Circle()
                    .fill(Color(hex: "#FF3B30"))
                    .frame(width: 8, height: 8)
                Text("Fine")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            HStack(spacing: 6) {
                Circle()
                    .fill(Color(hex: "#FF9500"))
                    .frame(width: 8, height: 8)
                Text("Wait 30m")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
    }
}

struct VotingButtons: View {
    @Binding var selectedVote: VoteOption?
    let votingData: VotingData
    
    var body: some View {
        VStack(spacing: 12) {
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedVote = .dontFine
                }
            }) {
                Text("Don't Fine (\(votingData.dontFineVotes))")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.glass)
            
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedVote = .fine
                }
            }) {
                Text("Fine (\(votingData.fineVotes))")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.glass)
            
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedVote = .wait
                }
            }) {
                Text("Wait 30m")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.glass)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }
}

struct VoteConfirmation: View {
    let vote: VoteOption?
    
    var body: some View {
        if let vote = vote {
            HStack {
                Text("You voted:")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.6))
                
                Text(voteText(for: vote))
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(voteColor(for: vote))
            }
            .transition(.opacity.combined(with: .scale(scale: 1.05)))
        }
    }
    
    private func voteText(for vote: VoteOption) -> String {
        switch vote {
        case .dontFine: return "Don't Fine"
        case .fine: return "Fine"
        case .wait: return "Wait 30m"
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

struct VoteResultsSection: View {
    let voteResults: VoteResults
    let message: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(message)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))
            
            VStack(alignment: .leading, spacing: 8) {
                GeometryReader { geometry in
                    HStack(spacing: 2) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: "#00D448"))
                            .frame(width: geometry.size.width * (Double(voteResults.dontFineVotes) / Double(voteResults.totalMembers)))
                        
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: "#FF3B30"))
                            .frame(width: geometry.size.width * (Double(voteResults.fineVotes) / Double(voteResults.totalMembers)))
                        
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: "#FF9500"))
                            .frame(width: geometry.size.width * (Double(voteResults.waitVotes) / Double(voteResults.totalMembers)))
                    }
                }
                .frame(height: 40)
                
                HStack(spacing: 16) {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color(hex: "#00D448"))
                            .frame(width: 8, height: 8)
                        Text("Don't Fine (\(voteResults.dontFineVotes))")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color(hex: "#FF3B30"))
                            .frame(width: 8, height: 8)
                        Text("Fine (\(voteResults.fineVotes))")
                            .font(.system(size: 11, weight: voteResults.fineVotes > voteResults.dontFineVotes ? .bold : .regular))
                            .foregroundColor(.white.opacity(voteResults.fineVotes > voteResults.dontFineVotes ? 0.9 : 0.7))
                    }
                    
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color(hex: "#FF9500"))
                            .frame(width: 8, height: 8)
                        Text("Wait (\(voteResults.waitVotes))")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                }
                
                Text("\(voteResults.totalMembers)/\(voteResults.totalMembers) pack members voted")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
    }
}

// MARK: - Data Models

enum CheckInActivityStatus {
    case success
    case late(minutesLate: Int)
    case pending(minutesLeft: Int)
    case failedVoting(votingData: VotingData)
    case fineActivated(voteResults: VoteResults)
    case forgiven(voteResults: VoteResults)
}

struct VotingData {
    let dontFineVotes: Int
    let fineVotes: Int
    let waitVotes: Int
    let totalMembers: Int
    let hoursLeft: Int
    var hasVoted: Bool
    var userVote: VoteOption?
}

struct VoteResults {
    let dontFineVotes: Int
    let fineVotes: Int
    let waitVotes: Int
    let totalMembers: Int
    let fineAmount: Int
}

enum VoteOption {
    case dontFine
    case fine
    case wait
}

// MARK: - Mock Data
struct MockCheckIn: Identifiable {
    let id = UUID()
    let userName: String
    let userInitials: String
    let packName: String
    let timeAgo: String
    let goalText: String
    let message: String?
    let proofImage: String?
    let streak: Int
    let likeCount: Int
    let commentCount: Int
    let xpEarned: Int
    let isLiked: Bool
    let isCurrentUser: Bool
    let status: CheckInActivityStatus
}

let mockCheckIns: [MockCheckIn] = [
    // TODAY - Success
    MockCheckIn(
        userName: "You",
        userInitials: "ME",
        packName: "Morning Warriors",
        timeAgo: "2m ago",
        goalText: "🏃‍♂️ 5km morning run",
        message: "Crushed it today! Feeling strong 💪",
        proofImage: "https://images.unsplash.com/photo-1571008887538-b36bb32f4571?w=800&q=80",
        streak: 7,
        likeCount: 12,
        commentCount: 3,
        xpEarned: 150,
        isLiked: true,
        isCurrentUser: true,
        status: .success
    ),
    
    // TODAY - Late Check-In
    MockCheckIn(
        userName: "Sarah Kim",
        userInitials: "SK",
        packName: "Code & Coffee",
        timeAgo: "3h ago",
        goalText: "💻 2 hours deep work",
        message: "Finally fixed that bug!",
        proofImage: nil,
        streak: 3,
        likeCount: 8,
        commentCount: 1,
        xpEarned: 75,
        isLiked: false,
        isCurrentUser: false,
        status: .late(minutesLate: 30)
    ),
    
    // TODAY - Pending
    MockCheckIn(
        userName: "You",
        userInitials: "ME",
        packName: "Fitness Freaks",
        timeAgo: "Due in 2h",
        goalText: "🏋️ Gym session",
        message: nil,
        proofImage: nil,
        streak: 14,
        likeCount: 0,
        commentCount: 0,
        xpEarned: 0,
        isLiked: false,
        isCurrentUser: true,
        status: .pending(minutesLeft: 154)
    ),

    // YESTERDAY - Success
    MockCheckIn(
        userName: "Mike Johnson",
        userInitials: "MJ",
        packName: "Fitness Freaks",
        timeAgo: "Yesterday",
        goalText: "🏋️ Gym session complete",
        message: "Leg day = best day",
        proofImage: "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&q=80",
        streak: 14,
        likeCount: 24,
        commentCount: 5,
        xpEarned: 200,
        isLiked: true,
        isCurrentUser: false,
        status: .success
    ),
    
    // YESTERDAY - Failed Voting
    MockCheckIn(
        userName: "Sarah Kim",
        userInitials: "SK",
        packName: "Book Club",
        timeAgo: "Yesterday",
        goalText: "📚 Read 30 pages",
        message: nil,
        proofImage: nil,
        streak: 5,
        likeCount: 0,
        commentCount: 0,
        xpEarned: 0,
        isLiked: false,
        isCurrentUser: false,
        status: .failedVoting(votingData: VotingData(
            dontFineVotes: 3,
            fineVotes: 1,
            waitVotes: 1,
            totalMembers: 8,
            hoursLeft: 18,
            hasVoted: false,
            userVote: nil
        ))
    ),
    
    // YESTERDAY - Fine Activated
    MockCheckIn(
        userName: "You",
        userInitials: "ME",
        packName: "Book Club",
        timeAgo: "Yesterday",
        goalText: "📚 Read 30 pages",
        message: nil,
        proofImage: nil,
        streak: 0,
        likeCount: 0,
        commentCount: 0,
        xpEarned: 0,
        isLiked: false,
        isCurrentUser: true,
        status: .fineActivated(voteResults: VoteResults(
            dontFineVotes: 2,
            fineVotes: 4,
            waitVotes: 2,
            totalMembers: 8,
            fineAmount: 5
        ))
    ),
    
    // YESTERDAY - Forgiven
    MockCheckIn(
        userName: "Alex Chen",
        userInitials: "AC",
        packName: "Early Birds",
        timeAgo: "Yesterday",
        goalText: "☀️ Wake up at 6am",
        message: nil,
        proofImage: nil,
        streak: 10,
        likeCount: 0,
        commentCount: 0,
        xpEarned: 0,
        isLiked: false,
        isCurrentUser: false,
        status: .forgiven(voteResults: VoteResults(
            dontFineVotes: 6,
            fineVotes: 1,
            waitVotes: 1,
            totalMembers: 8,
            fineAmount: 5
        ))
    ),

    // EARLIER - Success
    MockCheckIn(
        userName: "Jordan Lee",
        userInitials: "JL",
        packName: "Early Birds",
        timeAgo: "3 days ago",
        goalText: "☀️ Wake up at 6am",
        message: "Another day, another win!",
        proofImage: "https://images.unsplash.com/photo-1495616811223-4d98c6e9c869?w=800&q=80",
        streak: 21,
        likeCount: 31,
        commentCount: 7,
        xpEarned: 250,
        isLiked: true,
        isCurrentUser: false,
        status: .success
    )
]

#Preview {
    NavigationStack {
        FeedView()
    }
}
