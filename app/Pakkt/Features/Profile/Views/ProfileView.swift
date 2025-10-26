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
                                
                                HStack(spacing: 8) {
                                    Image(systemName: "crown.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(.yellow)
                                    Text("FREE")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.primary)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(.yellow.opacity(0.1))
                                .clipShape(.capsule)
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