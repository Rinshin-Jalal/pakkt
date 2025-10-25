import SwiftUI

struct FeedView: View {
    @State private var showCreateCheckIn = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Background with native dark mode support
            Color(.systemBackground)
                .ignoresSafeArea()
                .background(.ultraThinMaterial)
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 20) {  // Reduced from 50
                        // Earlier This Week (OLDEST - at top)
                        DateDivider(text: "Earlier this week")

                        ForEach(mockCheckIns.dropFirst(4)) { checkIn in
                            CheckInCard(checkIn: checkIn, isCurrentUser: checkIn.isCurrentUser)
                                .padding(.horizontal, checkIn.isCurrentUser ? 0 : 16)  // Reduced from 24
                                .padding(.trailing, checkIn.isCurrentUser ? 16 : 0)  // Reduced from 24
                                .padding(.leading, checkIn.isCurrentUser ? 16 : 0)   // Reduced from 24
                        }
                

                        Spacer().frame(height: 10)  // Reduced from 30

                        // Yesterday Section
                        DateDivider(text: "Yesterday")

                        // FINE ACTIVATED CARD
                        FineActivatedCard()
                            .padding(.horizontal, 16)  // Reduced from 24

                        Spacer().frame(height: 8)  // Reduced from 20

                        ForEach(mockCheckIns.dropFirst(2).prefix(2)) { checkIn in
                            CheckInCard(checkIn: checkIn, isCurrentUser: checkIn.isCurrentUser)
                                .padding(.horizontal, checkIn.isCurrentUser ? 0 : 16)  // Reduced from 24
                                .padding(.trailing, checkIn.isCurrentUser ? 16 : 0)  // Reduced from 24
                                .padding(.leading, checkIn.isCurrentUser ? 16 : 0)   // Reduced from 24
                        }

                        Spacer().frame(height: 20)  // Reduced from 40

                        // Today Section (NEWEST - at bottom)
                        DateDivider(text: "Today")

                        // NEXT GOAL REMINDER CARD
                        NextGoalCard()
                            .padding(.horizontal, 16)  // Reduced from 24

                        Spacer().frame(height: 8)  // Reduced from 20

                        ForEach(mockCheckIns.prefix(2)) { checkIn in
                            CheckInCard(checkIn: checkIn, isCurrentUser: checkIn.isCurrentUser)
                                .padding(.horizontal, checkIn.isCurrentUser ? 0 : 16)  // Reduced from 24
                                .padding(.trailing, checkIn.isCurrentUser ? 16 : 0)  // Reduced from 24
                                .padding(.leading, checkIn.isCurrentUser ? 16 : 0)   // Reduced from 24
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

// MARK: - Fine Activated Card - Liquid Glass
struct FineActivatedCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
     

            // Card Body with glass effect
            VStack(alignment: .leading, spacing: 16) {
                // ⚠️ WARNING BANNER - Red gradient
                HStack {
                    Text("⚠️ Fine Activated")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Text("$5")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                // User + Goal
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color(.red).opacity(0.2))
                        .frame(width: 44, height: 44)
                        .overlay(
                            Text("ME")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(hex: "#FF3B30"))
                        )

                    VStack(alignment: .leading, spacing: 4) {
                        Text("You")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)

                        Text("📚 Read 30 pages")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }

                Divider()
                    .background(Color.white.opacity(0.2))

                // Voting section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Pack is voting on this fine")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))

                    HStack(spacing: 20) {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(Color(hex: "#00D448"))
                            Text("3")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }

                        HStack(spacing: 8) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(Color(hex: "#FF3B30"))
                            Text("1")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }

                        Spacer()

                        Text("18h left")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
            }
            .padding(20)
            .glassEffect(in: .rect(cornerRadius: 20))
        }
    }
}




// MARK: - Check-In Card Component
struct CheckInCard: View {
    let checkIn: MockCheckIn
    let isCurrentUser: Bool

    private var accentColor: Color {
        // Glass card with blue accent for high streaks
        if checkIn.streak > 5 {
            return Color(hex: "#0066FF")
        } else {
            return Color.white.opacity(0.15)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                if isCurrentUser {
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


         
            HStack {
                if isCurrentUser { Spacer(minLength: 50) }
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {  // Proper spacing between header and content
                        // Goal Text - BOLD HEADER with glass effect
                        Text(checkIn.goalText)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 0)
                            .padding(.top, 16)
                            .padding(.bottom, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Proof Image
                        if let _ = checkIn.proofImage {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black.opacity(0.4))
                                .aspectRatio(1/1, contentMode: .fit)
                                .overlay(
                                    Image(systemName: "photo.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.white.opacity(0.3))
                                )
                        }
                        
                        // Check-in message
                        if let message = checkIn.message {
                            Text(message)
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        
                        // Bottom: Streak + XP + Actions
                        HStack(spacing: 16) {
                            
                            
                            // XP Badge - Amber
                            HStack(spacing: 6) {
                                Text("+\(checkIn.xpEarned)")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.primary)
                                Text("xp")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .glassEffect(.regular.tint(.green.opacity(0.1)),in: .capsule)
                            
                            Spacer()
                            
                            // Like
                            Button(action: {}) {
                                HStack(spacing: 6) {
                                    Image(systemName: checkIn.isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                    Text("\(checkIn.likeCount)")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                            }
                            
                            // Comment
                            Button(action: {}) {
                                HStack(spacing: 6) {
                                    Image(systemName: "message.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                    Text("\(checkIn.commentCount)")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .padding(16)  // Reduced from 20
                    .glassEffect(in: .rect(cornerRadius: 16))  // Reduced from 20
                }
                if !isCurrentUser { Spacer(minLength: 40) }

            }
        }
    }
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
    let isCurrentUser: Bool // NEW: for message-style alignment
}

let mockCheckIns: [MockCheckIn] = [
    // TODAY
    MockCheckIn(
        userName: "You",
        userInitials: "ME",
        packName: "Morning Warriors",
        timeAgo: "2m ago",
        goalText: "🏃‍♂️ 5km morning run",
        message: "Crushed it today! Feeling strong 💪",
        proofImage: "running",
        streak: 7,
        likeCount: 12,
        commentCount: 3,
        xpEarned: 150,
        isLiked: true,
        isCurrentUser: true // YOUR POST
    ),
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
        xpEarned: 100,
        isLiked: false,
        isCurrentUser: false
    ),

    // YESTERDAY
    MockCheckIn(
        userName: "Mike Johnson",
        userInitials: "MJ",
        packName: "Fitness Freaks",
        timeAgo: "Yesterday",
        goalText: "🏋️ Gym session complete",
        message: "Leg day = best day",
        proofImage: "gym",
        streak: 14,
        likeCount: 24,
        commentCount: 5,
        xpEarned: 200,
        isLiked: true,
        isCurrentUser: false
    ),
    MockCheckIn(
        userName: "You",
        userInitials: "ME",
        packName: "Book Club",
        timeAgo: "Yesterday",
        goalText: "📚 Read 30 pages",
        message: "This book is incredible!",
        proofImage: nil,
        streak: 5,
        likeCount: 6,
        commentCount: 2,
        xpEarned: 75,
        isLiked: false,
        isCurrentUser: true // YOUR POST
    ),

    // EARLIER
    MockCheckIn(
        userName: "Jordan Lee",
        userInitials: "JL",
        packName: "Early Birds",
        timeAgo: "3 days ago",
        goalText: "☀️ Wake up at 6am",
        message: "Another day, another win!",
        proofImage: "sunrise",
        streak: 21,
        likeCount: 31,
        commentCount: 7,
        xpEarned: 250,
        isLiked: true,
        isCurrentUser: false
    )
]

#Preview {
    NavigationStack {
        FeedView()
    }
}
