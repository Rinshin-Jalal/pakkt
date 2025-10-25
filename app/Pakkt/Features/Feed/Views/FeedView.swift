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

                        // CHECK-IN FAILED CARD (Voting)
                        CheckInFailedCard()
                            .padding(.horizontal, 16)

                        Spacer().frame(height: 8)
                        
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

// MARK: - Check-In Failed Card - Voting System
struct CheckInFailedCard: View {
    @State private var selectedVote: VoteOption? = nil
    
    enum VoteOption {
        case dontFine
        case fine
        case wait
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Card Body with glass effect
            VStack(alignment: .leading, spacing: 16) {
           
                // User + Goal
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color(hex: "#FF9500").opacity(0.2))
                        .frame(width: 44, height: 44)
                        .overlay(
                            Text("SK")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(hex: "#FF9500"))
                        )

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Sarah Kim")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)

                        Text("📚 Read 30 pages")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    Text("18h left")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.6))
                }
                // ⚠️ WARNING BANNER - Orange/Yellow
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
                

                Divider()
                    .background(Color.white.opacity(0.2))

                // Voting section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Should Sarah be fined?")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                    
                    // Progress bar showing vote distribution
                    VStack(alignment: .leading, spacing: 8) {
                        GeometryReader { geometry in
                            HStack(spacing: 2) {
                                // Don't Fine segment (3 votes)
                                RoundedRectangle(cornerRadius: selectedVote != nil ? 12 : 8)
                                    .fill(Color(hex: "#00D448"))
                                    .frame(width: geometry.size.width * (3.0 / 8.0))
                                
                                // Fine segment (1 vote)
                                RoundedRectangle(cornerRadius: selectedVote != nil ? 12 : 8)
                                    .fill(Color(hex: "#FF3B30"))
                                    .frame(width: geometry.size.width * (1.0 / 8.0))
                                
                                // Wait segment (1 vote)
                                RoundedRectangle(cornerRadius: selectedVote != nil ? 12 : 8)
                                    .fill(Color(hex: "#FF9500"))
                                    .frame(width: geometry.size.width * (1.0 / 8.0))
                                
                                // Remaining votes (3 left)
                                RoundedRectangle(cornerRadius: selectedVote != nil ? 12 : 8)
                                    .fill(Color.white.opacity(0.1))
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .frame(height: selectedVote != nil ? 40 : 20)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedVote)
                        
                        // Legend with color markers
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
                        
                        Text("5/8 pack members voted")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.6))
                    }

                    // Voting buttons - Simple text (disappear when voted)
                    if selectedVote == nil {
                        VStack(spacing: 12) {
                            // Don't Fine
                            Button(action: { 
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedVote = .dontFine
                                }
                            }) {
                                Text("Don't Fine (3)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                            }
                            .buttonStyle(.glass)
                            
                            // Fine
                            Button(action: { 
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedVote = .fine
                                }
                            }) {
                                Text("Fine (1)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                            }
                            .buttonStyle(.glass)
                            
                            // Wait 30 mins
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
                    } else {
                        // Show what you voted for
                        HStack {
                            Text("You voted:")
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.6))
                            
                            Text(selectedVote == .dontFine ? "Don't Fine" : selectedVote == .fine ? "Fine" : "Wait 30m")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(selectedVote == .dontFine ? Color(hex: "#00D448") : selectedVote == .fine ? Color(hex: "#FF3B30") : Color(hex: "#FF9500"))
                        }
                        .transition(.opacity.combined(with: .scale(scale: 1.05)))
                    }
                }
            }
            .padding(20)
            .glassEffect(in: .rect(cornerRadius: 30))
        }
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
                    Text("Pack voted to fine you")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                    
                    // Progress bar showing final vote results
                    VStack(alignment: .leading, spacing: 8) {
                        GeometryReader { geometry in
                            HStack(spacing: 2) {
                                // Don't Fine segment (2 votes)
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(hex: "#00D448"))
                                    .frame(width: geometry.size.width * (2.0 / 8.0))
                                
                                // Fine segment (4 votes - MAJORITY)
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(hex: "#FF3B30"))
                                    .frame(width: geometry.size.width * (4.0 / 8.0))
                                
                                // Wait segment (2 votes)
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(hex: "#FF9500"))
                                    .frame(width: geometry.size.width * (2.0 / 8.0))
                            }
                        }
                        .frame(height: 40)
                        
                        // Legend with color markers
                        HStack(spacing: 16) {
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(Color(hex: "#00D448"))
                                    .frame(width: 8, height: 8)
                                Text("Don't Fine (2)")
                                    .font(.system(size: 11))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(Color(hex: "#FF3B30"))
                                    .frame(width: 8, height: 8)
                                Text("Fine (4)")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                            
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(Color(hex: "#FF9500"))
                                    .frame(width: 8, height: 8)
                                Text("Wait (2)")
                                    .font(.system(size: 11))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            
                            Spacer()
                        }
                        
                        Text("8/8 pack members voted")
                            .font(.system(size: 12))
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
                    VStack(alignment: .leading, spacing: 10) {
                        // Goal Text - BOLD HEADER with glass effect
                        Text(checkIn.goalText)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 0)
                            .padding(.top, 16)
                            .padding(.bottom, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Check-in message
                        if let message = checkIn.message {
                            Text(message)
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        
                        // Bottom section with image background
                        ZStack(alignment: .topLeading) {
                            // Background Image (if exists)
                            if let imageURL = checkIn.proofImage {
                                GeometryReader { geo in
                                    AsyncImage(url: URL(string: imageURL)) { phase in
                                        switch phase {
                                        case .empty:
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.black.opacity(0.4))
                                                .overlay(
                                                    ProgressView()
                                                        .tint(.white)
                                                )
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
                            
                            // Bottom: Streak + XP + Actions overlaid on image
                            VStack(spacing: 0) {
                                Spacer()
                                
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
                                    .padding(.horizontal, 10)
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
                                    }.buttonStyle(.glass)
                                    
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
        proofImage: "https://images.unsplash.com/photo-1571008887538-b36bb32f4571?w=800&q=80",
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
        proofImage: "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&q=80",
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
        proofImage: "https://images.unsplash.com/photo-1512820790803-83ca734da794?w=800&q=80",
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
        proofImage: "https://images.unsplash.com/photo-1495616811223-4d98c6e9c869?w=800&q=80",
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
