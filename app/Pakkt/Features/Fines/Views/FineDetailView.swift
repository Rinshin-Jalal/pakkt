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
            // Background with native dark mode support
            Color(.systemBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // Fine Status Card
                    VStack(spacing: 16) {
                        // Header
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.red)

                            Text("FINE ACTIVATED")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primary)

                            Spacer()

                            Text(fineAmount)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.red)
                        }

                        Divider()

                        // Fine Details
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("WHO")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.secondary)

                                Spacer()

                                Text(finedUser)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.primary)
                            }

                            HStack {
                                Text("MISSED")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.secondary)

                                Spacer()

                                Text(missedGoal)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.primary)
                            }

                            HStack {
                                Text("VOTING ENDS")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.secondary)

                                Spacer()

                                Text(votingEndsIn)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding(20)
                    .glassEffect(in: .rect(cornerRadius: 20))
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                    // Voting Results Card
                    VStack(spacing: 16) {
                        // Header
                        HStack {
                            Image(systemName: "chart.bar.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.primary)

                            Text("PACK VOTE")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.primary)

                            Spacer()

                            Text("\(enforceVotes + dismissVotes)/\(packMembers.count)")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.secondary)
                        }

                        // Vote Bars
                        VStack(spacing: 16) {
                            // Enforce Bar
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("ENFORCE")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text("\(enforceVotes)")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.primary)
                                }

                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.secondary.opacity(0.2))
                                            .frame(height: 30)

                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.green)
                                            .frame(
                                                width: geometry.size.width * CGFloat(enforceVotes) / CGFloat(packMembers.count),
                                                height: 30
                                            )
                                    }
                                }
                                .frame(height: 30)
                            }

                            // Dismiss Bar
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.pink)
                                    Text("DISMISS")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text("\(dismissVotes)")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.primary)
                                }

                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.secondary.opacity(0.2))
                                            .frame(height: 30)

                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.pink)
                                            .frame(
                                                width: geometry.size.width * CGFloat(dismissVotes) / CGFloat(packMembers.count),
                                                height: 30
                                            )
                                    }
                                }
                                .frame(height: 30)
                            }
                        }
                    }
                    .padding(20)
                    .glassEffect(in: .rect(cornerRadius: 20))
                    .padding(.horizontal, 16)

                    // Your Vote Section (if not voted yet)
                    if !hasVoted {
                        VStack(spacing: 16) {
                            // Header
                            HStack {
                                Image(systemName: "hand.raised.fill")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.primary)

                                Text("CAST YOUR VOTE")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.primary)

                                Spacer()
                            }

                            VStack(spacing: 12) {
                                // Enforce Button
                                Button(action: {
                                    userVote = true
                                    hasVoted = true
                                }) {
                                    HStack {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 24, weight: .semibold))
                                            .foregroundColor(.white)

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("ENFORCE FINE")
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(.white)

                                            Text("They should pay \(fineAmount)")
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundColor(.white.opacity(0.8))
                                        }

                                        Spacer()

                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(.white)
                                    }
                                    .padding(16)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.green)
                                    .cornerRadius(16)
                                }

                                // Dismiss Button
                                Button(action: {
                                    userVote = false
                                    hasVoted = true
                                }) {
                                    HStack {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.system(size: 24, weight: .semibold))
                                            .foregroundColor(.white)

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("DISMISS FINE")
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(.white)

                                            Text("Give them a pass")
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundColor(.white.opacity(0.8))
                                        }

                                        Spacer()

                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(.white)
                                    }
                                    .padding(16)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.pink)
                                    .cornerRadius(16)
                                }
                            }
                        }
                        .padding(20)
                        .glassEffect(in: .rect(cornerRadius: 20))
                        .padding(.horizontal, 16)
                    } else {
                        // Vote Confirmed
                        VStack(spacing: 16) {
                            HStack {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.green)

                                Text("VOTE RECORDED")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.primary)

                                Spacer()
                            }

                            HStack {
                                Text("You voted to \(userVote == true ? "ENFORCE" : "DISMISS") this fine")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.primary)

                                Spacer()

                                Image(systemName: userVote == true ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(userVote == true ? .green : .pink)
                            }
                        }
                        .padding(20)
                        .glassEffect(in: .rect(cornerRadius: 20))
                        .padding(.horizontal, 16)
                    }

                    // Appeal Button
                    if finedUser == "You" {
                        Button(action: {
                            showAppealSheet = true
                        }) {
                            HStack {
                                Image(systemName: "exclamationmark.bubble.fill")
                                    .font(.system(size: 18, weight: .semibold))

                                Text("APPEAL THIS FINE")
                                    .font(.system(size: 15, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.orange)
                            .cornerRadius(16)
                        }
                        .padding(.horizontal, 16)
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
                Color(.systemBackground)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("Explain why this fine should be dismissed")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                        .padding(.top, 20)

                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "text.bubble.fill")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.primary)

                            Text("YOUR APPEAL")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.primary)

                            Spacer()
                        }

                        ZStack(alignment: .topLeading) {
                            if appealReason.isEmpty {
                                Text("I couldn't complete this because...")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary.opacity(0.5))
                                    .padding(.horizontal, 8)
                                    .padding(.top, 8)
                            }

                            TextEditor(text: $appealReason)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primary)
                                .frame(height: 200)
                                .padding(4)
                                .scrollContentBackground(.hidden)
                        }
                    }
                    .padding(20)
                    .glassEffect(in: .rect(cornerRadius: 20))
                    .padding(.horizontal, 16)

                    Button(action: {
                        // TODO: Submit appeal
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "paperplane.fill")
                                .font(.system(size: 18, weight: .semibold))

                            Text("SUBMIT APPEAL")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.orange)
                        .cornerRadius(16)
                    }
                    .padding(.horizontal, 16)

                    Spacer()
                }
            }
            .navigationTitle("Appeal Fine")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
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
