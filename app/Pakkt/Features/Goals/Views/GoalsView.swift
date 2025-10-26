import SwiftUI

struct GoalsView: View {
    @State private var selectedSegment = GoalSegment.myTasks
    @State private var showCreateGoal = false
    
    // Mock data for user's personal tasks
    let myTasks: [GoalItem] = [
        GoalItem(
            id: UUID(),
            title: "🏋️ Gym session",
            time: "6:00 PM",
            fineAmount: 5,
            jailDuration: 30,
            streak: 14,
            status: .pending(minutesLeft: 84),
            isCurrentUser: true,
            goalType: .personal,
            creator: nil
        ),
        GoalItem(
            id: UUID(),
            title: "📚 Read 30 pages",
            time: "9:00 PM",
            fineAmount: 3,
            jailDuration: 15,
            streak: 7,
            status: .pending(minutesLeft: 204),
            isCurrentUser: true,
            goalType: .personal,
            creator: nil
        )
    ]
    
    // Mock data for other users' personal tasks (visible to pack)
    let otherUsersTasks: [GoalItem] = [
        GoalItem(
            id: UUID(),
            title: "🏃‍♂️ Morning run 5km",
            time: "7:00 AM",
            fineAmount: 6,
            jailDuration: 20,
            streak: 3,
            status: .completed,
            isCurrentUser: false,
            goalType: .personal,
            creator: GoalCreator(username: "Sarah Kim", initials: "SK")
        ),
        GoalItem(
            id: UUID(),
            title: "💻 2 hours deep work",
            time: "2:00 PM",
            fineAmount: 8,
            jailDuration: 45,
            streak: 12,
            status: .completed,
            isCurrentUser: false,
            goalType: .personal,
            creator: GoalCreator(username: "Mike Johnson", initials: "MJ")
        )
    ]
    
    // Mock data for pack tasks (shared goals)
    let packTasks: [GoalItem] = [
        GoalItem(
            id: UUID(),
            title: "🍽️ No junk food today",
            time: "11:59 PM",
            fineAmount: 4,
            jailDuration: 25,
            streak: 9,
            status: .pending(minutesLeft: 1439),
            isCurrentUser: true,
            goalType: .pack,
            creator: GoalCreator(username: "You", initials: "ME")
        ),
        GoalItem(
            id: UUID(),
            title: "📱 No phone after 10pm",
            time: "10:00 PM",
            fineAmount: 7,
            jailDuration: 35,
            streak: 6,
            status: .pending(minutesLeft: 599),
            isCurrentUser: false,
            goalType: .pack,
            creator: GoalCreator(username: "Alex Chen", initials: "AC")
        ),
        GoalItem(
            id: UUID(),
            title: "💧 Drink 8 glasses of water",
            time: "11:59 PM",
            fineAmount: 2,
            jailDuration: 10,
            streak: 11,
            status: .completed,
            isCurrentUser: false,
            goalType: .pack,
            creator: GoalCreator(username: "David Lee", initials: "DL")
        )
    ]
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Background with native dark mode support
            Color.clear
                .ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Segment Picker
                    Picker("Goal Type", selection: $selectedSegment) {
                        ForEach(GoalSegment.allCases, id: \.self) { segment in
                            Text(segment.title)
                                .tag(segment)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    
                    // Goals based on selected segment
                    switch selectedSegment {
                    case .myTasks:
                        PersonalGoalsSection(goals: myTasks)
                    case .otherUsersTasks:
                        PackGoalsSection(goals: otherUsersTasks)
                    case .packTasks:
                        PackGoalsSection(goals: packTasks)
                    }
                    
                    Spacer().frame(height: 80)
                }
            }
            .navigationTitle("My Tasks")
            .navigationBarTitleDisplayMode(.large)

            // Primary Action - Create Goal
            Button(action: { showCreateGoal = true }) {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    }
                    .buttonStyle(.borderedProminent)
            .padding(24)
        }
        .sheet(isPresented: $showCreateGoal) {
            CreateGoalView()
        }
    }
}

// MARK: - Personal Goals Section
struct PersonalGoalsSection: View {
    let goals: [GoalItem]
    
    var body: some View {
        VStack(spacing: 20) {
            // Active Goals Section
            if hasActiveGoals {
                Text("ACTIVE GOALS")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                
                ForEach(goals.filter { goal in
                    if case .pending = goal.status {
                        return true
                    }
                    return false
                }) { goal in
                    GoalCard(goal: goal)
                }
            }
            
            // Completed Goals Section
            if hasCompletedGoals {
                Text("COMPLETED TODAY")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, hasActiveGoals ? 24 : 16)
                
                ForEach(goals.filter { $0.status == .completed }) { goal in
                    GoalCard(goal: goal)
                }
            }
        }
    }
    
    private var hasActiveGoals: Bool {
        goals.contains { goal in
            if case .pending = goal.status {
                return true
            }
            return false
        }
    }
    
    private var hasCompletedGoals: Bool {
        goals.contains { goal in
            goal.status == .completed
        }
    }
}

// MARK: - Pack Goals Section
struct PackGoalsSection: View {
    let goals: [GoalItem]
    
    var body: some View {
        VStack(spacing: 20) {
            // Active Pack Goals Section
            if hasActiveGoals {
                Text("ACTIVE PACK GOALS")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                
                ForEach(goals.filter { goal in
                    if case .pending = goal.status {
                        return true
                    }
                    return false
                }) { goal in
                    PackGoalCard(goal: goal)
                }
            }
            
            // Completed Pack Goals Section
            if hasCompletedGoals {
                Text("COMPLETED TODAY")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, hasActiveGoals ? 24 : 16)
                
                ForEach(goals.filter { $0.status == .completed }) { goal in
                    PackGoalCard(goal: goal)
                }
            }
        }
    }
    
    private var hasActiveGoals: Bool {
        goals.contains { goal in
            if case .pending = goal.status {
                return true
            }
            return false
        }
    }
    
    private var hasCompletedGoals: Bool {
        goals.contains { goal in
            goal.status == .completed
        }
    }
}

// MARK: - Personal Goal Card Component
struct GoalCard: View {
    let goal: GoalItem
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                // Goal info
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(goal.title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        
                        if goal.streak > 0 {
                            HStack(spacing: 2) {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 10))
                                    .foregroundColor(.orange)
                                Text("\(goal.streak)")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.primary)
                            }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.orange.opacity(0.1))
                            .clipShape(.capsule)
                        }
                    }
                    
                    Text("Due \(goal.time)")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Status indicator
                statusView
            }
            
            // Consequences row
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Text("$\(goal.fineAmount)")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.primary)
                    Text("fine")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 4) {
                    Text("\(goal.jailDuration)m")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.primary)
                    Text("jail")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if case .pending = goal.status {
                    Button("Check In") {
                        // TODO: Check in action
                    }
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .glassEffect(in: .capsule)
                }
            }
        }
        .padding(16)
        .glassEffect(in: .rect(cornerRadius: 16))
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private var statusView: some View {
        if case .pending(let minutesLeft) = goal.status {
            VStack(spacing: 2) {
                Text(formatTime(minutesLeft))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.orange)
                Text("LEFT")
                    .font(.system(size: 8, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            .frame(width: 60, height: 50)
            .glassEffect(in: .rect(cornerRadius: 10))
        } else if goal.status == .completed {
            VStack(spacing: 2) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.green)
                Text("Done")
                    .font(.system(size: 8, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            .frame(width: 60, height: 50)
            .glassEffect(in: .rect(cornerRadius: 10))
        }
    }
    
    private func formatTime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        return "\(hours):\(String(format: "%02d", mins))"
    }
}

// MARK: - Pack Goal Card Component
struct PackGoalCard: View {
    let goal: GoalItem
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                // Creator avatar
                VStack(spacing: 2) {
                    Circle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 32, height: 32)
                        .overlay(
                            Text(goal.creator?.initials ?? "UK")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                        )
                    
                    Text(goal.creator?.username ?? "Unknown")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                }
                .frame(width: 36)
                
                // Goal info
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(goal.title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        
                        if goal.streak > 0 {
                            HStack(spacing: 2) {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 10))
                                    .foregroundColor(.orange)
                                Text("\(goal.streak)")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.primary)
                            }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.orange.opacity(0.1))
                            .clipShape(.capsule)
                        }
                    }
                    
                    Text("Due \(goal.time)")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Status indicator
                statusView
            }
            
            // Consequences row
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Text("$\(goal.fineAmount)")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.primary)
                    Text("fine")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 4) {
                    Text("\(goal.jailDuration)m")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.primary)
                    Text("jail")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
        }
        .padding(16)
        .glassEffect(in: .rect(cornerRadius: 16))
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private var statusView: some View {
        if case .pending(let minutesLeft) = goal.status {
            VStack(spacing: 2) {
                Text(formatTime(minutesLeft))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.orange)
                Text("LEFT")
                    .font(.system(size: 8, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            .frame(width: 60, height: 50)
            .glassEffect(in: .rect(cornerRadius: 10))
        } else if goal.status == .completed {
            VStack(spacing: 2) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.green)
                Text("Done")
                    .font(.system(size: 8, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            .frame(width: 60, height: 50)
            .glassEffect(in: .rect(cornerRadius: 10))
        }
    }
    
    private func formatTime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        return "\(hours):\(String(format: "%02d", mins))"
    }
}

// MARK: - Supporting Types
enum GoalSegment: CaseIterable {
    case myTasks
    case otherUsersTasks
    case packTasks
    
    var title: String {
        switch self {
        case .myTasks: return "My Tasks"
        case .otherUsersTasks: return "Others' Tasks"
        case .packTasks: return "Pack Tasks"
        }
    }
}

struct GoalItem: Identifiable {
    let id: UUID
    let title: String
    let time: String
    let fineAmount: Int
    let jailDuration: Int
    let streak: Int
    let status: GoalStatus
    let isCurrentUser: Bool
    let goalType: GoalType
    let creator: GoalCreator?
}

enum GoalStatus: Equatable {
    case pending(minutesLeft: Int)
    case completed
    case missed
}

struct GoalCreator {
    let username: String
    let initials: String
}

// MARK: - Create Goal View
struct CreateGoalView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State private var time: Date = Date()
    @State private var fineAmount: Double = 5.0
    @State private var jailDuration: Double = 30.0
    @State private var proofRequired: Bool = true
    @State private var goalType: GoalType = .personal
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Goal Type Selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("GOAL TYPE")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)
                        
                        HStack {
                            Button(role: .none) {
                                goalType = .personal
                            } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(goalType == .personal ? .blue : .secondary)
                                    
                                    Text("Personal")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(goalType == .personal ? .primary : .secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.ultraThinMaterial)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(goalType == .personal ? .blue.opacity(0.3) : .clear, lineWidth: 2)
                                        )
                                )
                            }
                            
                            Button(role: .none) {
                                goalType = .pack
                            } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "person.2.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(goalType == .pack ? .blue : .secondary)
                                    
                                    Text("Pack")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(goalType == .pack ? .primary : .secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.ultraThinMaterial)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(goalType == .pack ? .blue.opacity(0.3) : .clear, lineWidth: 2)
                                        )
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    
                    // Goal Title
                    VStack(alignment: .leading, spacing: 12) {
                        Text("GOAL TITLE")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)
                        
                        TextField("e.g., Gym session", text: $title)
                            .padding(16)
                            .background(.ultraThinMaterial, in: .rect(cornerRadius: 12))
                            .padding(.horizontal, 16)
                    }
                    
                    // Time Selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("TIME")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)
                        
                        DatePicker(
                            "Select time",
                            selection: $time,
                            displayedComponents: [.hourAndMinute]
                        )
                        .datePickerStyle(.compact)
                        .padding(16)
                        .glassEffect(in: .rect(cornerRadius: 12))
                        .padding(.horizontal, 16)
                    }
                    
                    // Fine Amount
                    VStack(alignment: .leading, spacing: 12) {
                        Text("FINE AMOUNT ($)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)
                        
                        HStack {
                            Slider(
                                value: $fineAmount,
                                in: 1...20,
                                step: 1
                            )
                            .padding(.horizontal, 16)
                            
                            Text("$\(Int(fineAmount))")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primary)
                                .frame(width: 40)
                        }
                        .padding(16)
                        .glassEffect(in: .rect(cornerRadius: 12))
                        .padding(.horizontal, 16)
                    }
                    
                    // Jail Duration
                    VStack(alignment: .leading, spacing: 12) {
                        Text("JAIL DURATION (MINUTES)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)
                        
                        HStack {
                            Slider(
                                value: $jailDuration,
                                in: 15...60,
                                step: 15
                            )
                            .padding(.horizontal, 16)
                            
                            Text("\(Int(jailDuration))m")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primary)
                                .frame(width: 60)
                        }
                        .padding(16)
                        .glassEffect(in: .rect(cornerRadius: 12))
                        .padding(.horizontal, 16)
                    }
                    
                    // Proof Required Toggle
                    VStack(alignment: .leading, spacing: 12) {
                        Text("REQUIRE PROOF")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)
                        
                        Toggle(isOn: $proofRequired) {
                            Text("Require photo proof")
                                .font(.system(size: 16))
                                .foregroundColor(.primary)
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        .padding(16)
                        .glassEffect(in: .rect(cornerRadius: 12))
                        .padding(.horizontal, 16)
                    }
                    
                    // Create Goal Button
                    Button(action: {
                        // TODO: Create goal
                        dismiss()
                    }) {
                        HStack {
                            Text("Create Goal")
                                .font(.system(size: 20, weight: .bold))
                                .frame(maxWidth: .infinity).foregroundColor(.primary)
                        }
                        .padding(.vertical, 16)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    Spacer(minLength: 20)
                }
            }
            .navigationTitle("Create Goal")
        }
    }
}

#Preview {
    NavigationStack {
        GoalsView()
    }
}
