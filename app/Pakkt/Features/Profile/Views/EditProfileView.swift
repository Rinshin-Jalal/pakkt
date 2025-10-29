import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    let profile: UserProfile
    @ObservedObject var viewModel: ProfileViewModel
    
    @State private var username: String
    @State private var bio: String
    @State private var isSaving = false
    
    init(profile: UserProfile, viewModel: ProfileViewModel) {
        self.profile = profile
        self.viewModel = viewModel
        _username = State(initialValue: profile.username)
        _bio = State(initialValue: profile.bio ?? "")
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Profile Picture
                        VStack(spacing: 16) {
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
                                                .font(.system(size: 32, weight: .bold))
                                                .foregroundColor(.white)
                                        )
                                }
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                            } else {
                                Circle()
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: [.blue, .purple]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                                    .frame(width: 100, height: 100)
                                    .overlay(
                                        Text(profile.username.prefix(2).uppercased())
                                            .font(.system(size: 32, weight: .bold))
                                            .foregroundColor(.white)
                                    )
                            }
                            
                            Button(action: {
                                // TODO: Implement photo picker
                            }) {
                                Text("Change Photo")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.top, 20)
                        
                        // Username Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("USERNAME")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 16)
                            
                            TextField("Username", text: $username)
                                .font(.system(size: 16))
                                .foregroundColor(.primary)
                                .padding(16)
                                .glassEffect(in: .rect(cornerRadius: 12))
                        }
                        .padding(.horizontal, 20)
                        
                        // Bio Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("BIO")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 16)
                            
                            ZStack(alignment: .topLeading) {
                                if bio.isEmpty {
                                    Text("Tell us about yourself...")
                                        .font(.system(size: 16))
                                        .foregroundColor(.secondary)
                                        .padding(16)
                                }
                                
                                TextEditor(text: $bio)
                                    .font(.system(size: 16))
                                    .foregroundColor(.primary)
                                    .scrollContentBackground(.hidden)
                                    .frame(minHeight: 100)
                                    .padding(12)
                            }
                            .glassEffect(in: .rect(cornerRadius: 12))
                        }
                        .padding(.horizontal, 20)
                        
                        // Email (Read-only)
                        if let email = profile.email {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("EMAIL")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 16)
                                
                                HStack {
                                    Text(email)
                                        .font(.system(size: 16))
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Image(systemName: "lock.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(.secondary)
                                }
                                .padding(16)
                                .glassEffect(in: .rect(cornerRadius: 12))
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        Spacer(minLength: 20)
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await saveProfile()
                        }
                    }
                    .disabled(isSaving || !hasChanges)
                }
            }
            .overlay {
                if isSaving {
                    ZStack {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                        
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.white)
                    }
                }
            }
        }
    }
    
    private var hasChanges: Bool {
        username != profile.username || bio != (profile.bio ?? "")
    }
    
    private func saveProfile() async {
        isSaving = true
        
        let newUsername = username != profile.username ? username : nil
        let newBio = bio != (profile.bio ?? "") ? (bio.isEmpty ? nil : bio) : nil
        
        await viewModel.updateProfile(
            username: newUsername,
            profilePic: nil,
            bio: newBio
        )
        
        isSaving = false
        
        if viewModel.errorMessage == nil {
            dismiss()
        }
    }
}

#Preview {
    EditProfileView(profile: .mock, viewModel: ProfileViewModel())
}
