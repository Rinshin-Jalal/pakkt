import SwiftUI

struct CheckInDetailView: View {
    let checkIn: MockCheckIn
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header with user info
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color.secondary.opacity(0.2))
                            .frame(width: 50, height: 50)
                            .overlay {
                                Text(checkIn.userInitials)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.primary)
                            }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(checkIn.userName)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Text(checkIn.timeAgo)
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.secondary)
                                .frame(width: 32, height: 32)
                                .background {
                                    Circle()
                                        .fill(Color.secondary.opacity(0.1))
                                }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Photo
                    if let imageName = checkIn.proofImage {
                        Image(systemName: imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 400)
                            .frame(maxWidth: .infinity)
                            .background(Color.secondary.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(.horizontal, 20)
                    }
                    
                    // Caption
                    if let message = checkIn.message {
                        Text(message)
                            .font(.system(size: 16))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                    }
                    
                    // Stats
                    HStack(spacing: 12) {
                        CheckInStatItem(
                            icon: "flame.fill",
                            color: .orange,
                            value: "\(checkIn.streak)",
                            label: "Streak"
                        )
                        
                        CheckInStatItem(
                            icon: "star.fill",
                            color: .yellow,
                            value: "+\(checkIn.xpEarned)",
                            label: "XP"
                        )
                        
                        if case .success = checkIn.status {
                            CheckInStatItem(
                                icon: "checkmark.seal.fill",
                                color: .green,
                                value: "Verified",
                                label: ""
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Goal info
                    VStack(alignment: .leading, spacing: 12) {
                        Text("GOAL")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Image(systemName: "target")
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                            
                            Text(checkIn.goalText)
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .padding(16)
                        .glassEffect(in: .rect(cornerRadius: 16))
                    }
                    .padding(.horizontal, 20)
                    
                    // Pack info
                    VStack(alignment: .leading, spacing: 12) {
                        Text("PACK")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Image(systemName: "person.3.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.purple)
                            
                            Text(checkIn.packName)
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .padding(16)
                        .glassEffect(in: .rect(cornerRadius: 16))
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .padding(.bottom, 40)
            }
        }
    }
}

struct CheckInStatItem: View {
    let icon: String
    let color: Color
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.primary)
            
            if !label.isEmpty {
                Text(label)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .glassEffect(in: .rect(cornerRadius: 16))
    }
}

#Preview {
    CheckInDetailView(checkIn: mockCheckIns[0])
}
