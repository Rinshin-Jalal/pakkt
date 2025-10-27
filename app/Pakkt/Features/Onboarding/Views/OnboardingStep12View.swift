import SwiftUI

struct OnboardingStep12View: View {
    @State private var selectedContacts: Set<String> = []
    let minimumRequired = 3
    let maximumAllowed = 10
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("WHO'S GOT YOUR BACK?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .textCase(.uppercase)
                        
                        Text("Who in your life would actually hold you accountable?")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Gym Friends
                    ContactSection(
                        title: "GYM FRIENDS",
                        icon: "figure.strengthtraining.traditional",
                        contacts: gymFriends,
                        selectedContacts: $selectedContacts
                    )
                    
                    // Study Buddies
                    ContactSection(
                        title: "STUDY BUDDIES",
                        icon: "book.fill",
                        contacts: studyBuddies,
                        selectedContacts: $selectedContacts
                    )
                    
                    // Roommates/Family
                    ContactSection(
                        title: "ROOMMATES/FAMILY",
                        icon: "house.fill",
                        contacts: roommates,
                        selectedContacts: $selectedContacts
                    )
                    
                    // Progress
                    VStack(spacing: 12) {
                        HStack {
                            Text("Selected: \(selectedContacts.count)/\(minimumRequired) minimum needed")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                            Spacer()
                        }
                        
                        ProgressView(value: Double(selectedContacts.count), total: Double(minimumRequired))
                            .tint(Color(hex: "00F0FF"))
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer().frame(height: 40)
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        Button(action: {
                            // Continue action
                        }) {
                            Text("CONTINUE")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                        }
                        .buttonStyle(.glass)
                        .disabled(selectedContacts.count < minimumRequired)
                        .opacity(selectedContacts.count >= minimumRequired ? 1 : 0.5)
                        
                        Button(action: {
                            // Add custom contact
                        }) {
                            Text("ADD CUSTOM CONTACT")
                                .font(.system(size: 15))
                                .foregroundColor(Color(hex: "00F0FF"))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
    }
    
    // Mock data
    private var gymFriends: [Contact] {
        [
            Contact(id: "1", name: "Jake", emoji: "💪", description: "Already goes to gym"),
            Contact(id: "2", name: "Mike", emoji: "🏋️", description: "Same schedule"),
            Contact(id: "3", name: "Tom", emoji: "⚡", description: "Competitive")
        ]
    }
    
    private var studyBuddies: [Contact] {
        [
            Contact(id: "4", name: "Sarah", emoji: "📚", description: "Same major"),
            Contact(id: "5", name: "Lisa", emoji: "✏️", description: "Study partner")
        ]
    }
    
    private var roommates: [Contact] {
        [
            Contact(id: "6", name: "Alex", emoji: "⏰", description: "Sees your routine"),
            Contact(id: "7", name: "Mom", emoji: "👩", description: "Worried about you")
        ]
    }
}

struct ContactSection: View {
    let title: String
    let icon: String
    let contacts: [Contact]
    @Binding var selectedContacts: Set<String>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section Header
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "00F0FF"))
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .textCase(.uppercase)
            }
            .padding(.horizontal, 20)
            
            // Contacts Grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(contacts) { contact in
                    ContactCard(
                        contact: contact,
                        isSelected: selectedContacts.contains(contact.id)
                    ) {
                        if selectedContacts.contains(contact.id) {
                            selectedContacts.remove(contact.id)
                        } else {
                            selectedContacts.insert(contact.id)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct ContactCard: View {
    let contact: Contact
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Text(contact.emoji)
                    .font(.system(size: 32))
                
                Text(contact.name)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                
                Text(contact.description)
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "plus.circle")
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? Color(hex: "00F0FF") : .white.opacity(0.4))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(isSelected ? 0.12 : 0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(
                        isSelected ? Color(hex: "00F0FF").opacity(0.5) : Color.white.opacity(0.1),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct Contact: Identifiable {
    let id: String
    let name: String
    let emoji: String
    let description: String
}

#Preview {
    OnboardingStep12View()
}
