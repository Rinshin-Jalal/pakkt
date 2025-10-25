import SwiftUI

struct CreateCheckInView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedGoal: String = "🏋️ Gym session"
    @State private var message: String = ""
    @State private var hasPhoto: Bool = false

    let availableGoals = [
        "🏋️ Gym session",
        "🏃‍♂️ 5km morning run",
        "💻 2 hours deep work",
        "📚 Read 30 pages",
        "☀️ Wake up at 6am"
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Camera/Photo Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("PROOF PHOTO")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)
                            .padding(.top, 16)

                        Button(action: {
                            hasPhoto.toggle()
                        }) {
                            HStack {
                                Image(systemName: hasPhoto ? "photo.fill" : "camera.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.secondary)
                                    .padding(12)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(hasPhoto ? "TAP TO RETAKE" : "TAP TO CAPTURE")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.primary)
                                    
                                    Text("Add proof of your accomplishment")
                                        .font(.system(size: 12))
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.bottom, 16)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glassEffect(in: .rect(cornerRadius: 16))
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    
                    // Goal Selection Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("SELECT GOAL")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)
                            .padding(.top, 16)

                        ForEach(availableGoals, id: \.self) { goal in
                            Button(action: {
                                selectedGoal = goal
                            }) {
                                HStack {
                                    Text(goal)
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(.primary)

                                    Spacer()

                                    if selectedGoal == goal {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 20))
                                    } else {
                                        Image(systemName: "circle")
                                            .font(.system(size: 20))
                                            .foregroundColor(Color(.label).opacity(0.3))
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .if(selectedGoal == goal) { view in
                                    view.glassEffect(in: .rect(cornerRadius: 16))
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glassEffect(in: .rect(cornerRadius: 16))
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    
                    // Message Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("ADD MESSAGE (OPTIONAL)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)
                            .padding(.top, 16)

                        ZStack(alignment: .topLeading) {
                            if message.isEmpty {
                                Text("Share your thoughts...")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary.opacity(0.6))
                                    .padding(.top, 8)
                                    .padding(.horizontal, 16)
                            }
                            TextEditor(text: $message)
                                .font(.system(size: 14))
                                .foregroundColor(.primary)
                                .frame(height: 100)
                                .padding(.horizontal, 12)
                                .scrollContentBackground(.hidden)
                        }
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glassEffect(in: .rect(cornerRadius: 16))
                    .padding(16)
                    .padding(.top, 8)
                    
                    // Submit Button
                    Button(action: {
                        // TODO: Submit check-in
                        dismiss()
                    }) {
                        HStack {
                            Text("Check In")
                                .font(.system(size: 20, weight: .bold))
                                .frame(maxWidth: .infinity).foregroundStyle(Color(.label))
                        }
                        .padding(.vertical, 16)
                        
                        
                    }.buttonStyle(.glassProminent)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    
                    Spacer(minLength: 20)
                }
            }
            .navigationTitle("Check In")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Text("Cancel")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

#Preview {
    CreateCheckInView()
}
