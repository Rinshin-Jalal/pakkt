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
    let onContinue: () -> Void
    @State private var selectedContacts: Set<String> = []
    @State private var selectedContactNames: [String] = []
    @State private var showingContactPicker = false
    @State private var hasRequestedAccess = false
    @State private var contactAccessGranted = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Header
                VStack(spacing: 12) {
                    Text("INVITE YOUR PACK")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(2.0)
                    
                    Text("Optional - you can do this later")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Contact selection box
                VStack(spacing: 20) {
                    // Explanation
                    Text("Pick people from your contacts who will hold you accountable")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    // Selected contacts
                    if !selectedContactNames.isEmpty {
                        VStack(spacing: 8) {
                            ForEach(selectedContactNames, id: \.self) { name in
                                HStack(spacing: 10) {
                                    Text(name)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        if let index = selectedContactNames.firstIndex(of: name) {
                                            selectedContactNames.remove(at: index)
                                        }
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.system(size: 16))
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    
                    // Select button
                    Button(action: {
                        requestContactAccess()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "person.crop.circle.badge.plus")
                                .font(.system(size: 16))
                            Text(selectedContactNames.isEmpty ? "SELECT CONTACTS" : "ADD MORE")
                                .font(.system(size: 15, weight: .semibold))
                                .tracking(1.0)
                        }
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 16)
                    .buttonStyle(.glass)
                }
                .padding(.vertical, 24)
                .glassEffect(in: .rect(cornerRadius: 30))
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Actions
                VStack(spacing: 12) {
                    Button(action: onContinue) {
                        HStack(spacing: 8) {
                            Text("CONTINUE")
                                .font(.system(size: 16, weight: .bold))
                                .tracking(1.0)
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                    }
                    .buttonStyle(.glass)
                    
                    Button(action: onContinue) {
                        Text("SKIP FOR NOW")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)
                            .tracking(1.0)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .sheet(isPresented: $showingContactPicker) {
            SimpleContactPickerView(
                selectedContactNames: $selectedContactNames
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

struct SimpleContactPickerView: View {
    @Binding var selectedContactNames: [String]
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
                Color(.systemBackground).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        
                        TextField("Search contacts", text: $searchText)
                            .foregroundColor(.primary)
                    }
                    .padding(12)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    
                    // Contacts list
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(filteredContacts) { contact in
                                Button(action: {
                                    if selectedContactNames.contains(contact.name) {
                                        selectedContactNames.removeAll { $0 == contact.name }
                                    } else {
                                        selectedContactNames.append(contact.name)
                                    }
                                }) {
                                    HStack(spacing: 12) {
                                        Circle()
                                            .fill(Color.secondary.opacity(0.2))
                                            .frame(width: 40, height: 40)
                                            .overlay(
                                                Text(contact.name.prefix(1).uppercased())
                                                    .font(.system(size: 16, weight: .semibold))
                                                    .foregroundColor(.primary)
                                            )
                                        
                                        Text(contact.name)
                                            .font(.system(size: 16))
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        
                                        if selectedContactNames.contains(contact.name) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.system(size: 24))
                                                .foregroundColor(.blue)
                                        } else {
                                            Image(systemName: "circle")
                                                .font(.system(size: 24))
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .padding(12)
                                }
                            }
                        }
                        .padding(20)
                    }
                }
            }
            .navigationTitle("Select Contacts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            loadContacts()
        }
    }
    
    private func loadContacts() {
        let store = CNContactStore()
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)
        
        var loadedContacts: [ContactItem] = []
        
        do {
            try store.enumerateContacts(with: request) { contact, _ in
                let fullName = "\(contact.givenName) \(contact.familyName)".trimmingCharacters(in: .whitespaces)
                
                if !fullName.isEmpty {
                    loadedContacts.append(ContactItem(
                        id: contact.identifier,
                        name: fullName,
                        phoneNumber: nil
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

#Preview {
    OnboardingStep12View(onContinue: {})
}
