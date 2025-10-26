import SwiftUI

struct ProfileView: View {
    @State private var showingSignOutAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Header
                    VStack(spacing: 16) {
                        Circle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [.blue, .purple]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Text("JL")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.white)
                            )
                        
                        VStack(spacing: 8) {
                            Text("Jordan Lee")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.primary)
                            
                            HStack(spacing: 12) {
                                Text("jordan.lee@example.com")
                                    .font(.system(size: 16))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(24)
                    .glassEffect(in: .rect(cornerRadius: 20))
                    .padding(.horizontal, 20)
                    
                    
                    // Stats Overview
                    VStack(spacing: 20) {
                        Text("Your Stats")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                            .padding(.top, 20)
                        
                        HStack(spacing: 16) {
                            VStack(spacing: 12) {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.orange)
                                
                                Text("7")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.primary)
                                
                                Text("Current Streak")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .glassEffect(in: .rect(cornerRadius: 12))
                            
                            VStack(spacing: 12) {
                                Image(systemName: "target")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.green)
                                
                                Text("87")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.primary)
                                
                                Text("Check-ins")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .glassEffect(in: .rect(cornerRadius: 12))
                            
                            VStack(spacing: 12) {
                                Image(systemName: "dollarsign.circle.fill")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.red)
                                
                                Text("$42")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.primary)
                                
                                Text("Total Fines")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .glassEffect(in: .rect(cornerRadius: 12))
                    }
                    .padding(.horizontal, 20)
                    
                    // Edit Profile Button
                    Button(action: {
                        print("Edit profile tapped")
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
                        Text("Account Settings")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                            .padding(.top, 20)
                        
                        VStack(spacing: 8) {
                            Button(action: {
                                print("Notifications tapped")
                            }) {
                                HStack {
                                    Image(systemName: "bell")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.blue)
                                        .frame(width: 24)
                                    Text("Notifications")
                                        .font(.system(size: 16))
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                            }
                            .glassEffect(in: .rect(cornerRadius: 12))
                            
                            Button(action: {
                                print("Privacy tapped")
                            }) {
                                HStack {
                                    Image(systemName: "lock.shield")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.green)
                                        .frame(width: 24)
                                    Text("Privacy")
                                        .font(.system(size: 16))
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                            }
                            .glassEffect(in: .rect(cornerRadius: 12))
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Help & Support Section
                    VStack(spacing: 12) {
                        Text("Help & Support")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                            .padding(.top, 20)
                        
                        VStack(spacing: 8) {
                            Button(action: {
                                print("FAQ tapped")
                            }) {
                                HStack {
                                    Image(systemName: "questionmark.circle")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.orange)
                                        .frame(width: 24)
                                    Text("FAQ")
                                        .font(.system(size: 16))
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                            }
                            .glassEffect(in: .rect(cornerRadius: 12))
                            
                            Button(action: {
                                print("Contact Support tapped")
                            }) {
                                HStack {
                                    Image(systemName: "envelope")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.purple)
                                        .frame(width: 24)
                                    Text("Contact Support")
                                        .font(.system(size: 16))
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                            }
                            .glassEffect(in: .rect(cornerRadius: 12))
                            
                            Button(action: {
                                print("Report a Bug tapped")
                            }) {
                                HStack {
                                    Image(systemName: "ant")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.red)
                                        .frame(width: 24)
                                    Text("Report a Bug")
                                        .font(.system(size: 16))
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                            }
                            .glassEffect(in: .rect(cornerRadius: 12))
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // App Version
                    VStack(spacing: 8) {
                        Text("App Version")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        Text("Version 1.0.0 (Build 1)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 20)
                    
                    // Edit Profile Button
                    Button(action: {
                        print("Edit profile tapped")
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
                    .padding(.horizontal, 20)
                    
                    // Account Settings Section
                    VStack(spacing: 12) {
                        Text("Account Settings")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        
                        VStack(spacing: 8) {
                            Button(action: {
                                print("Notifications tapped")
                            }) {
                                HStack {
                                    Image(systemName: "bell")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.blue)
                                        .frame(width: 24)
                                    Text("Notifications")
                                        .font(.system(size: 16))
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                            }
                            .glassEffect(in: .rect(cornerRadius: 12))
                            
                            Button(action: {
                                print("Privacy tapped")
                            }) {
                                HStack {
                                    Image(systemName: "lock.shield")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.green)
                                        .frame(width: 24)
                                    Text("Privacy")
                                        .font(.system(size: 16))
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                            }
                            .glassEffect(in: .rect(cornerRadius: 12))
                        }
                        .padding(.horizontal, 0)
                    }
                    .padding(.horizontal, 20)
                    
                    // Help & Support Section
                    VStack(spacing: 12) {
                        Text("Help & Support")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        
                        VStack(spacing: 8) {
                            Button(action: {
                                print("FAQ tapped")
                            }) {
                                HStack {
                                    Image(systemName: "questionmark.circle")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.orange)
                                        .frame(width: 24)
                                    Text("FAQ")
                                        .font(.system(size: 16))
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                            }
                            .glassEffect(in: .rect(cornerRadius: 12))
                            
                            Button(action: {
                                print("Contact Support tapped")
                            }) {
                                HStack {
                                    Image(systemName: "envelope")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.purple)
                                        .frame(width: 24)
                                    Text("Contact Support")
                                        .font(.system(size: 16))
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                            }
                            .glassEffect(in: .rect(cornerRadius: 12))
                            
                            Button(action: {
                                print("Report a Bug tapped")
                            }) {
                                HStack {
                                    Image(systemName: "ant")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.red)
                                        .frame(width: 24)
                                    Text("Report a Bug")
                                        .font(.system(size: 16))
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                            }
                            .glassEffect(in: .rect(cornerRadius: 12))
                        }
                        .padding(.horizontal, 0)
                    }
                    .padding(.horizontal, 20)
                    
                    // App Version
                    VStack(spacing: 8) {
                        Text("App Version")
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
                    .padding(.horizontal, 24)
                    
                    // Sign Out Button
                    Button(action: {
                        showingSignOutAlert = true
                    }) {
                        Text("Sign Out")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                    }
                    .glassEffect(in: .capsule)
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 40)
                }
            }
            .padding(.top, 20)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
        .alert("Sign Out", isPresented: $showingSignOutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                print("User signed out")
            }
        } message: {
            Text("Are you sure you want to sign out? You'll need to log in again to access your account.")
        }
    }
}

#Preview {
    ProfileView()
}
