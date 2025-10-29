import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var showingEditProfile = false
    @State private var showingSignOutAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if viewModel.isLoading && viewModel.profile == nil {
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding(.top, 100)
                    } else if let profile = viewModel.profile {
                        profileContent(profile: profile)
                    } else {
                        errorView
                    }
                }
            }
            .padding(.top, 20)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .task {
                await viewModel.loadProfile()
            }
            .refreshable {
                await viewModel.loadProfile()
            }
        }
        .sheet(isPresented: $showingEditProfile) {
            if let profile = viewModel.profile {
                EditProfileView(profile: profile, viewModel: viewModel)
            }
        }
        .alert("Sign Out", isPresented: $showingSignOutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                coordinator.signOut()
            }
        } message: {
            Text("Are you sure you want to sign out? You'll need to log in again to access your account.")
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
    
    @ViewBuilder
    private func profileContent(profile: UserProfile) -> some View {
        VStack(spacing: 20) {
            // Profile Header
            VStack(spacing: 16) {
                // Profile Picture
                if let profilePic = profile.profilePic, let url = URL(string: profilePic) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Circle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [.blue, .purple]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .overlay(
                                Text(profile.username.prefix(2).uppercased())
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.white)
                            )
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                } else {
                    Circle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Text(profile.username.prefix(2).uppercased())
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                        )
                }
                
                VStack(spacing: 8) {
                    Text(profile.username)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                    
                    if let email = profile.email {
                        Text(email)
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                    
                    if let bio = profile.bio {
                        Text(bio)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                }
            }
            .padding(24)
            .glassEffect(in: .rect(cornerRadius: 20))
            .padding(.horizontal, 20)
            
            // Stats Overview
            VStack(spacing: 20) {
                Text("YOUR STATS")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                
                HStack(spacing: 16) {
                    StatCard(
                        icon: "flame.fill",
                        color: .orange,
                        value: "\(profile.currentStreak)",
                        label: "Current Streak"
                    )
                    
                    StatCard(
                        icon: "target",
                        color: .green,
                        value: "\(profile.totalCheckins)",
                        label: "Check-ins"
                    )
                    
                    StatCard(
                        icon: "dollarsign.circle.fill",
                        color: .red,
                        value: "$\(profile.totalFinesPaid)",
                        label: "Total Fines"
                    )
                }
                .padding(.horizontal, 20)
                
                // Edit Profile Button
                Button(action: {
                    showingEditProfile = true
                }) {
                    HStack {
                        Image(systemName: "pencil")
                            .font(.system(size: 16, weight: .medium))
                        Text("Edit Profile")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                }
                .glassEffect(in: .capsule)
                .padding(.horizontal, 24)
                
                // Account Settings Section
                VStack(spacing: 12) {
                    Text("ACCOUNT SETTINGS")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                    
                    VStack(spacing: 8) {
                        NavigationLink(destination: NotificationSettingsView()) {
                            SettingsRow(
                                icon: "bell",
                                color: .blue,
                                title: "Notifications"
                            )
                        }
                        
                        Button(action: {
                            // TODO: Navigate to privacy settings
                        }) {
                            SettingsRow(
                                icon: "lock.shield",
                                color: .green,
                                title: "Privacy"
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                // Help & Support Section
                VStack(spacing: 12) {
                    Text("HELP & SUPPORT")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                    
                    VStack(spacing: 8) {
                        Button(action: {
                            // TODO: Navigate to FAQ
                        }) {
                            SettingsRow(
                                icon: "questionmark.circle",
                                color: .orange,
                                title: "FAQ"
                            )
                        }
                        
                        Button(action: {
                            // TODO: Open email support
                        }) {
                            SettingsRow(
                                icon: "envelope",
                                color: .purple,
                                title: "Contact Support"
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                // App Version
                VStack(spacing: 8) {
                    Text("APP VERSION")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    Text("Version 1.0.0 (Build 1)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primary)
                }
                .padding(.top, 20)
                .padding(.bottom, 10)
            }
            
            // Sign Out Button
            Button(action: {
                showingSignOutAlert = true
            }) {
                Text("Sign Out")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .glassEffect(in: .capsule)
            .padding(.horizontal, 24)
            
            Spacer(minLength: 40)
        }
    }
    
    private var errorView: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.orange)
            
            Text("Unable to Load Profile")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button("Try Again") {
                Task {
                    await viewModel.loadProfile()
                }
            }
            .glassEffect(in: .capsule)
            .padding(.horizontal, 60)
            .padding(.top, 8)
        }
        .padding(.top, 100)
    }
}

// MARK: - Stat Card Component
struct StatCard: View {
    let icon: String
    let color: Color
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
            
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .glassEffect(in: .rect(cornerRadius: 12))
    }
}

// MARK: - Settings Row Component
struct SettingsRow: View {
    let icon: String
    let color: Color
    let title: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
                .frame(width: 24)
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .glassEffect(in: .rect(cornerRadius: 12))
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppCoordinator())
}
