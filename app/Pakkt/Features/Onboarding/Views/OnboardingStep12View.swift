import SwiftUI
import Contacts

struct ContactItem: Identifiable {
    let id: String
    let name: String
    let phoneNumber: String?
}

struct ContactCircle: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let description: String
}

struct OnboardingStep12View: View {
    @State private var selectedContacts: Set<String> = []
    @State private var showingContactPicker = false
    @State private var selectedCircle: ContactCircle?
    @State private var hasRequestedAccess = false
    @State private var contactAccessGranted = false
    
    let circles: [ContactCircle] = [
        ContactCircle(
            title: "GYM FRIENDS",
            icon: "figure.run",
            description: "Friends who work out or want to"
        ),
        ContactCircle(
            title: "STUDY BUDDIES",
            icon: "book.fill",
            description: "People you study or work with"
        ),
        ContactCircle(
            title: "ROOMMATES/FAMILY",
            icon: "house.fill",
            description: "People you live with or see daily"
        )
    ]
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Text("WHO'S GOT YOUR BACK?")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .textCase(.uppercase)
                        .padding(.top, 60)
                    
                    Text("Select people from your contacts who will hold you accountable")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                
                Spacer()
                
                // Contact Circles
                VStack(spacing: 16) {
                    ForEach(circles) { circle in
                        Button(action: {
                            selectedCircle = circle
                            requestContactAccess()
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: circle.icon)
                                    .font(.system(size: 20))
                                    .foregroundColor(.white.opacity(0.6))
                                    .frame(width: 40)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(circle.title)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                        .textCase(.uppercase)
                                    
                                    Text(circle.description)
                                        .font(.system(size: 13))
                                        .foregroundColor(.white.opacity(0.5))
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.3))
                            }
                            .padding(16)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                // Selected count
                if selectedContacts.count > 0 {
                    Text("\(selectedContacts.count) contacts selected")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
                
                // Actions
                VStack(spacing: 12) {
                    Button(action: {
                        // Continue action
                    }) {
                        Text("CONTINUE")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(selectedContacts.count >= 3 ? .white : .white.opacity(0.3))
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                    }
                    .buttonStyle(.glass)
                    .disabled(selectedContacts.count < 3)
                    
                    Text("Select at least 3 contacts")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.4))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .sheet(item: $selectedCircle) { circle in
            ContactPickerView(
                circle: circle,
                selectedContacts: $selectedContacts
            )
        }
    }
    
    private func requestContactAccess() {
        guard !hasRequestedAccess else {
            if contactAccessGranted {
                showingContactPicker = true
            }
            return
        }
        
        hasRequestedAccess = true
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            DispatchQueue.main.async {
                contactAccessGranted = granted
                if granted {
                    showingContactPicker = true
                }
            }
        }
    }
}

struct ContactPickerView: View {
    let circle: ContactCircle
    @Binding var selectedContacts: Set<String>
    @Environment(\.dismiss) var dismiss
    @State private var contacts: [ContactItem] = []
    @State private var searchText = ""
    
    var filteredContacts: [ContactItem] {
        if searchText.isEmpty {
            return contacts
        }
        return contacts.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white.opacity(0.4))
                        
                        TextField("Search contacts", text: $searchText)
                            .foregroundColor(.white)
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    
                    // Contacts list
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(filteredContacts) { contact in
                                ContactPickerRow(
                                    contact: contact,
                                    isSelected: selectedContacts.contains(contact.id),
                                    onTap: {
                                        if selectedContacts.contains(contact.id) {
                                            selectedContacts.remove(contact.id)
                                        } else {
                                            selectedContacts.insert(contact.id)
                                        }
                                    }
                                )
                            }
                        }
                        .padding(20)
                    }
                }
            }
            .navigationTitle(circle.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white.opacity(0.6))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                }
            }
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .onAppear {
            loadContacts()
        }
    }
    
    private func loadContacts() {
        let store = CNContactStore()
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)
        
        var loadedContacts: [ContactItem] = []
        
        do {
            try store.enumerateContacts(with: request) { contact, _ in
                let fullName = "\(contact.givenName) \(contact.familyName)".trimmingCharacters(in: .whitespaces)
                let phoneNumber = contact.phoneNumbers.first?.value.stringValue
                
                if !fullName.isEmpty {
                    loadedContacts.append(ContactItem(
                        id: contact.identifier,
                        name: fullName,
                        phoneNumber: phoneNumber
                    ))
                }
            }
            
            DispatchQueue.main.async {
                self.contacts = loadedContacts.sorted { $0.name < $1.name }
            }
        } catch {
            print("Failed to fetch contacts: \(error)")
        }
    }
}

struct ContactPickerRow: View {
    let contact: ContactItem
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 44, height: 44)
                    
                    Text(contact.name.prefix(1).uppercased())
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                // Name
                Text(contact.name)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Checkbox
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 24, height: 24)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(12)
            .background(isSelected ? Color.white.opacity(0.08) : Color.white.opacity(0.03))
            .cornerRadius(8)
        }
    }
}

#Preview {
    OnboardingStep12View()
}
