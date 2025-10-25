import SwiftUI

struct FineDetailView: View {
    @Environment(\.dismiss) var dismiss
    @State private var hasVoted: Bool = false
    @State private var userVote: Bool? = nil // true = enforce, false = dismiss
    @State private var showAppealSheet: Bool = false

    let fineId: String

    // Mock data
    let finedUser = "You"
    let missedGoal = "📚 Read 30 pages"
    let fineAmount = "$5"
    let enforceVotes = 3
    let dismissVotes = 1
    let votingEndsIn = "18h"
    let votingStatus = "active" // active, enforced, cancelled
    let packMembers = ["Alex Chen", "Sarah Kim", "Mike Johnson", "Emma Davis"]

    var body: some View {
        ZStack {
            // Background
            Color(red: 0.98, green: 0.97, blue: 0.95)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Fine Status Card
                    VStack(spacing: 0) {
                        // Header
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 24, weight: .black))
                                .foregroundColor(.black)

                            Text("FINE ACTIVATED")
                                .font(.system(size: 16, weight: .black))
                                .foregroundColor(.black)

                            Spacer()

                            Text(fineAmount)
                                .font(.system(size: 28, weight: .black))
                                .foregroundColor(.red)
                        }
                        .padding(16)
                        .background(Color.red.opacity(0.2))

                        // Fine Details
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("WHO:")
                                    .font(.system(size: 12, weight: .black))
                                    .foregroundColor(.black.opacity(0.5))

                                Spacer()

                                Text(finedUser)
                                    .font(.system(size: 16, weight: .black))
                                    .foregroundColor(.black)
                            }

                            Rectangle()
                                .fill(Color.black)
                                .frame(height: 2)

                            HStack {
                                Text("MISSED:")
                                    .font(.system(size: 12, weight: .black))
                                    .foregroundColor(.black.opacity(0.5))

                                Spacer()

                                Text(missedGoal)
                                    .font(.system(size: 16, weight: .black))
                                    .foregroundColor(.black)
                            }

                            Rectangle()
                                .fill(Color.black)
                                .frame(height: 2)

                            HStack {
                                Text("VOTING ENDS:")
                                    .font(.system(size: 12, weight: .black))
                                    .foregroundColor(.black.opacity(0.5))

                                Spacer()

                                Text(votingEndsIn)
                                    .font(.system(size: 16, weight: .black))
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(16)
                    }
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 3)
                    )
                    .rotationEffect(.degrees(-1))
                    .shadow(color: .black, radius: 0, x: 6, y: 6)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                    // Voting Results Card
                    VStack(spacing: 0) {
                        // Header
                        HStack {
                            Image(systemName: "chart.bar.fill")
                                .font(.system(size: 20, weight: .black))
                                .foregroundColor(.black)

                            Text("PACK VOTE")
                                .font(.system(size: 14, weight: .black))
                                .foregroundColor(.black)

                            Spacer()

                            Text("\(enforceVotes + dismissVotes)/\(packMembers.count)")
                                .font(.system(size: 14, weight: .black))
                                .foregroundColor(.black.opacity(0.5))
                        }
                        .padding(12)
                        .background(Color.purple.opacity(0.3))

                        // Vote Bars
                        VStack(spacing: 16) {
                            // Enforce Bar
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("ENFORCE")
                                        .font(.system(size: 13, weight: .black))
                                    Spacer()
                                    Text("\(enforceVotes)")
                                        .font(.system(size: 16, weight: .black))
                                }

                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                            .fill(Color.black.opacity(0.1))
                                            .frame(height: 30)
                                            .overlay(
                                                Rectangle()
                                                    .stroke(Color.black, lineWidth: 2)
                                            )

                                        Rectangle()
                                            .fill(Color.green)
                                            .frame(
                                                width: geometry.size.width * CGFloat(enforceVotes) / CGFloat(packMembers.count),
                                                height: 30
                                            )
                                            .overlay(
                                                Rectangle()
                                                    .stroke(Color.black, lineWidth: 2)
                                            )
                                    }
                                }
                                .frame(height: 30)
                            }

                            // Dismiss Bar
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                    Text("DISMISS")
                                        .font(.system(size: 13, weight: .black))
                                    Spacer()
                                    Text("\(dismissVotes)")
                                        .font(.system(size: 16, weight: .black))
                                }

                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                            .fill(Color.black.opacity(0.1))
                                            .frame(height: 30)
                                            .overlay(
                                                Rectangle()
                                                    .stroke(Color.black, lineWidth: 2)
                                            )

                                        Rectangle()
                                            .fill(Color.pink)
                                            .frame(
                                                width: geometry.size.width * CGFloat(dismissVotes) / CGFloat(packMembers.count),
                                                height: 30
                                            )
                                            .overlay(
                                                Rectangle()
                                                    .stroke(Color.black, lineWidth: 2)
                                            )
                                    }
                                }
                                .frame(height: 30)
                            }
                        }
                        .padding(16)
                    }
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 3)
                    )
                    .rotationEffect(.degrees(0.5))
                    .shadow(color: .black, radius: 0, x: 6, y: 6)
                    .padding(.horizontal, 20)

                    // Your Vote Section (if not voted yet)
                    if !hasVoted {
                        VStack(spacing: 0) {
                            // Header
                            HStack {
                                Image(systemName: "hand.raised.fill")
                                    .font(.system(size: 20, weight: .black))
                                    .foregroundColor(.black)

                                Text("CAST YOUR VOTE")
                                    .font(.system(size: 14, weight: .black))
                                    .foregroundColor(.black)

                                Spacer()
                            }
                            .padding(12)
                            .background(Color.yellow.opacity(0.5))

                            VStack(spacing: 12) {
                                // Enforce Button
                                Button(action: {
                                    userVote = true
                                    hasVoted = true
                                }) {
                                    HStack {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 24, weight: .black))
                                            .foregroundColor(.black)

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("ENFORCE FINE")
                                                .font(.system(size: 16, weight: .black))
                                                .foregroundColor(.black)

                                            Text("They should pay \(fineAmount)")
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundColor(.black.opacity(0.6))
                                        }

                                        Spacer()

                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 18, weight: .black))
                                            .foregroundColor(.black)
                                    }
                                    .padding(16)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.green)
                                    .cornerRadius(6)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(Color.black, lineWidth: 3)
                                    )
                                }

                                // Dismiss Button
                                Button(action: {
                                    userVote = false
                                    hasVoted = true
                                }) {
                                    HStack {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.system(size: 24, weight: .black))
                                            .foregroundColor(.black)

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("DISMISS FINE")
                                                .font(.system(size: 16, weight: .black))
                                                .foregroundColor(.black)

                                            Text("Give them a pass")
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundColor(.black.opacity(0.6))
                                        }

                                        Spacer()

                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 18, weight: .black))
                                            .foregroundColor(.black)
                                    }
                                    .padding(16)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.pink)
                                    .cornerRadius(6)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(Color.black, lineWidth: 3)
                                    )
                                }
                            }
                            .padding(16)
                        }
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 3)
                        )
                        .rotationEffect(.degrees(-0.5))
                        .shadow(color: .black, radius: 0, x: 6, y: 6)
                        .padding(.horizontal, 20)
                    } else {
                        // Vote Confirmed
                        VStack(spacing: 0) {
                            HStack {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.system(size: 20, weight: .black))
                                    .foregroundColor(.black)

                                Text("VOTE RECORDED")
                                    .font(.system(size: 14, weight: .black))
                                    .foregroundColor(.black)

                                Spacer()
                            }
                            .padding(12)
                            .background(Color.cyan.opacity(0.3))

                            HStack {
                                Text("You voted to \(userVote == true ? "ENFORCE" : "DISMISS") this fine")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.black)

                                Spacer()

                                Image(systemName: userVote == true ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(userVote == true ? .green : .pink)
                            }
                            .padding(16)
                            .background(Color.white)
                        }
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 3)
                        )
                        .rotationEffect(.degrees(0.5))
                        .shadow(color: .black, radius: 0, x: 6, y: 6)
                        .padding(.horizontal, 20)
                    }

                    // Appeal Button
                    if finedUser == "You" {
                        Button(action: {
                            showAppealSheet = true
                        }) {
                            HStack {
                                Image(systemName: "exclamationmark.bubble.fill")
                                    .font(.system(size: 18, weight: .black))

                                Text("APPEAL THIS FINE")
                                    .font(.system(size: 15, weight: .black))
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.orange)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 3)
                            )
                        }
                        .rotationEffect(.degrees(-0.5))
                        .shadow(color: .black, radius: 0, x: 6, y: 6)
                        .padding(.horizontal, 20)
                    }

                    Spacer(minLength: 40)
                }
            }
        }
        .navigationTitle("Fine Details")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showAppealSheet) {
            AppealFineView()
        }
    }
}

// MARK: - Appeal Fine View
struct AppealFineView: View {
    @Environment(\.dismiss) var dismiss
    @State private var appealReason: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.98, green: 0.97, blue: 0.95)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("Explain why this fine should be dismissed")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black.opacity(0.6))
                        .padding(.top, 20)

                    VStack(spacing: 0) {
                        HStack {
                            Image(systemName: "text.bubble.fill")
                                .font(.system(size: 18, weight: .black))
                                .foregroundColor(.black)

                            Text("YOUR APPEAL")
                                .font(.system(size: 14, weight: .black))
                                .foregroundColor(.black)

                            Spacer()
                        }
                        .padding(12)
                        .background(Color.orange.opacity(0.3))

                        ZStack(alignment: .topLeading) {
                            if appealReason.isEmpty {
                                Text("I couldn't complete this because...")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.black.opacity(0.3))
                                    .padding(.horizontal, 16)
                                    .padding(.top, 16)
                            }

                            TextEditor(text: $appealReason)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.black)
                                .frame(height: 200)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 8)
                                .scrollContentBackground(.hidden)
                                .background(Color.white)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 3)
                    )
                    .rotationEffect(.degrees(-0.5))
                    .shadow(color: .black, radius: 0, x: 6, y: 6)
                    .padding(.horizontal, 20)

                    Button(action: {
                        // TODO: Submit appeal
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "paperplane.fill")
                                .font(.system(size: 18, weight: .black))

                            Text("SUBMIT APPEAL")
                                .font(.system(size: 16, weight: .black))
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.orange)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 3)
                        )
                    }
                    .rotationEffect(.degrees(0.5))
                    .shadow(color: .black, radius: 0, x: 6, y: 6)
                    .padding(.horizontal, 20)

                    Spacer()
                }
            }
            .navigationTitle("Appeal Fine")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("CANCEL") {
                        dismiss()
                    }
                    .font(.system(size: 14, weight: .black))
                    .foregroundColor(.black)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        FineDetailView(fineId: "1")
    }
}
