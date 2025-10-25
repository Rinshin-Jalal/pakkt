import SwiftUI

struct FeedView: View {
    @State private var showCreateCheckIn = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Background
            Color.white
                .ignoresSafeArea()

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 50) {
                        // Earlier This Week (OLDEST - at top)
                        DateDivider(text: "EARLIER THIS WEEK")

                        ForEach(mockCheckIns.dropFirst(4)) { checkIn in
                            CheckInCard(checkIn: checkIn, isCurrentUser: checkIn.isCurrentUser)
                                .padding(.horizontal, checkIn.isCurrentUser ? 0 : 24)
                                .padding(.trailing, checkIn.isCurrentUser ? 24 : 0)
                                .padding(.leading, checkIn.isCurrentUser ? 24 : 0)
                        }

                        Spacer().frame(height: 30)

                        // STREAK MILESTONE
                        StreakMilestoneCard(userName: "Jordan Lee", streak: 21)
                            .padding(.horizontal, 24)

                        Spacer().frame(height: 30)

                        // Yesterday Section
                        DateDivider(text: "YESTERDAY")

                        // FINE ACTIVATED CARD
                        FineActivatedCard()
                            .padding(.horizontal, 24)

                        Spacer().frame(height: 20)

                        ForEach(mockCheckIns.dropFirst(2).prefix(2)) { checkIn in
                            CheckInCard(checkIn: checkIn, isCurrentUser: checkIn.isCurrentUser)
                                .padding(.horizontal, checkIn.isCurrentUser ? 0 : 24)
                                .padding(.trailing, checkIn.isCurrentUser ? 24 : 0)
                                .padding(.leading, checkIn.isCurrentUser ? 24 : 0)
                        }

                        Spacer().frame(height: 30)

                        // PACK LEVEL UP
                        PackLevelUpCard(newLevel: 5)
                            .padding(.horizontal, 24)

                        Spacer().frame(height: 40)

                        // Today Section (NEWEST - at bottom)
                        DateDivider(text: "TODAY")

                        // NEXT GOAL REMINDER CARD
                        NextGoalCard()
                            .padding(.horizontal, 24)

                        Spacer().frame(height: 20)

                        ForEach(mockCheckIns.prefix(2)) { checkIn in
                            CheckInCard(checkIn: checkIn, isCurrentUser: checkIn.isCurrentUser)
                                .padding(.horizontal, checkIn.isCurrentUser ? 0 : 24)
                                .padding(.trailing, checkIn.isCurrentUser ? 24 : 0)
                                .padding(.leading, checkIn.isCurrentUser ? 24 : 0)
                        }

                        // Bottom anchor
                        Color.clear
                            .frame(height: 1)
                            .id("bottom")
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 120)
                }
                .onAppear {
                    proxy.scrollTo("bottom", anchor: .bottom)
                }
            }
            .navigationTitle("My Pack")
            .navigationBarTitleDisplayMode(.large)

            // NEO-BRUTAL Floating Action Button
            Button(action: { showCreateCheckIn = true }) {
                Image(systemName: "camera.fill")
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(.black)
                    .frame(width: 60, height: 60)
                    .background(Color.green)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 3)
                    )
                    .rotationEffect(.degrees(-5))
                    .shadow(color: .black.opacity(0.5), radius: 0, x: 5, y: 5)
            }
            .padding(20)
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
            .font(.system(size: 11, weight: .black))
            .foregroundColor(.black.opacity(0.4))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
    }
}

// MARK: - Next Goal Reminder Card - BANNER STYLE
struct NextGoalCard: View {
    var body: some View {
        HStack(spacing: 12) {
            // Left: Timer circle
            VStack(spacing: 4) {
                Text("2:34")
                    .font(.system(size: 20, weight: .black))
                    .foregroundColor(.red)

                Text("LEFT")
                    .font(.system(size: 10, weight: .black))
                    .foregroundColor(.black.opacity(0.5))
            }
            .frame(width: 70, height: 70)


            // Right: Goal info
            VStack(alignment: .leading, spacing: 6) {
                Text("🏋️ Gym session")
                    .font(.system(size: 16, weight: .black))
                    .foregroundColor(.black)

                Text("Due by 6:00 PM")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.black.opacity(0.6))

                Text("TAP TO CHECK IN →")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.green)
            }

            Spacer()
        }
        .padding(12)
        .background(Color.orange)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black, lineWidth: 3)
        )
    }
}

// MARK: - Fine Activated Card - LOUD AND VISIBLE
struct FineActivatedCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // ⚠️ WARNING BANNER
            HStack {
                Text("⚠️ FINE ACTIVATED")
                    .font(.system(size: 13, weight: .black))
                    .foregroundColor(.white)
                Spacer()
                Text("$5")
                    .font(.system(size: 18, weight: .black))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.red)
            
            VStack(alignment: .leading, spacing: 16) {
                // User + Goal
                HStack(spacing: 10) {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 36, height: 36)
                        .overlay(
                            Text("ME")
                                .font(.system(size: 12, weight: .black))
                                .foregroundColor(.white)
                        )

                    VStack(alignment: .leading, spacing: 2) {
                        Text("You")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("📚 Read 30 pages")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black.opacity(0.8))
                    }
                }
                
                Divider()

                // Voting section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Pack is voting on this fine")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.black.opacity(0.6))

                    HStack(spacing: 16) {
                        HStack(spacing: 6) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.green)
                            Text("3")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                        }

                        HStack(spacing: 6) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.red)
                            Text("1")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                        }

                        Spacer()

                        Text("18h left")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.black.opacity(0.5))
                    }
                }
            }
            .padding(16)
            .background(Color.white)
        }
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.red, lineWidth: 3)
        )
        .rotationEffect(.degrees(-1.5))
        .shadow(color: .black.opacity(0.4), radius: 0, x: 5, y: 5)
    }
}

// MARK: - Streak Milestone Card - SMALL BADGE
struct StreakMilestoneCard: View {
    let userName: String
    let streak: Int

    var body: some View {
        HStack {
            Spacer()

            HStack(spacing: 8) {
                Text("🔥")
                    .font(.system(size: 24))

                VStack(alignment: .leading, spacing: 2) {
                    Text("\(userName)")
                        .font(.system(size: 13, weight: .black))
                        .foregroundColor(.black)

                    Text("\(streak) DAY STREAK!")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.orange)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black, lineWidth: 2)
            )

            Spacer()
        }
    }
}

// MARK: - Pack Level Up Card - SIMPLE
struct PackLevelUpCard: View {
    let newLevel: Int

    var body: some View {
        HStack {
            Spacer()

            HStack(spacing: 12) {
                Text("🎉")
                    .font(.system(size: 28))

                VStack(alignment: .leading, spacing: 2) {
                    Text("Pack Level \(newLevel)")
                        .font(.system(size: 16, weight: .black))
                        .foregroundColor(.black)

                    Text("Keep it up!")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.black.opacity(0.6))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.blue)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black, lineWidth: 3)
            )

            Spacer()
        }
    }
}

// MARK: - Check-In Card Component
struct CheckInCard: View {
    let checkIn: MockCheckIn
    let isCurrentUser: Bool

    private var accentColor: Color {
        [Color.yellow, Color.cyan, Color.pink, Color.green].randomElement()!
    }
    
    private var randomRotation: Double {
        Double.random(in: -1.0...1.0)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Avatar, name and time above card
            HStack(spacing: 8) {
                // Avatar on LEFT for others
                if !isCurrentUser {
                    
                    Text(checkIn.userName)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.black.opacity(0.7))
                }

                Text(checkIn.timeAgo)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.black.opacity(0.4))

                if isCurrentUser {
                    Text(checkIn.userName)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.black.opacity(0.7))
                            
                }
            }

            // Card content
            VStack(alignment: .leading, spacing: 0) {
                // Goal Text - BOLD HEADER
                Text(checkIn.goalText)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(accentColor)

                VStack(alignment: .leading, spacing: 12) {
                    // Proof Image
                    if let _ = checkIn.proofImage {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.black.opacity(0.05))
                            .aspectRatio(16/9, contentMode: .fit)
                            .overlay(
                                Image(systemName: "photo.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(.black.opacity(0.2))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }

                    // Check-in message
                    if let message = checkIn.message {
                        Text(message)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.black.opacity(0.8))
                    }

                    // Bottom: Streak + XP + Actions
                    HStack(spacing: 10) {
                        // Streak Badge
                        if checkIn.streak > 0 {
                            HStack(spacing: 4) {
                                Text("🔥")
                                    .font(.system(size: 13))
                                Text("\(checkIn.streak)")
                                    .font(.system(size: 13, weight: .black))
                                    .foregroundColor(.black)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 5)
                            .background(Color.orange.opacity(0.5))
                            .cornerRadius(6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                        }

                        // XP Badge
                        HStack(spacing: 4) {
                            Text("+\(checkIn.xpEarned)")
                                .font(.system(size: 13, weight: .black))
                                .foregroundColor(.black)
                            Text("XP")
                                .font(.system(size: 11, weight: .black))
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .background(Color.yellow.opacity(0.6))
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.black, lineWidth: 2)
                        )

                        Spacer()

                        // Like
                        Button(action: {}) {
                            HStack(spacing: 4) {
                                Image(systemName: checkIn.isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.black)
                                Text("\(checkIn.likeCount)")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.black)
                            }
                        }

                        // Comment
                        Button(action: {}) {
                            HStack(spacing: 4) {
                                Image(systemName: "message.fill")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.black)
                                Text("\(checkIn.commentCount)")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }
                .padding(14)
                .background(Color.white)
            }
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 2)
            )
            .rotationEffect(.degrees(randomRotation))
            .shadow(color: .black, radius: 0, x: -4, y: 4)
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
