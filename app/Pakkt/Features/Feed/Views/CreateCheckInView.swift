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
            ZStack {
                // Background
                Color(red: 0.98, green: 0.97, blue: 0.95)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Camera/Photo Section
                        VStack(spacing: 0) {
                            // Header
                            HStack {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 18, weight: .black))
                                    .foregroundColor(.black)

                                Text("PROOF PHOTO")
                                    .font(.system(size: 14, weight: .black))
                                    .foregroundColor(.black)

                                Spacer()

                                if hasPhoto {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.green)
                                }
                            }
                            .padding(12)
                            .background(Color.purple.opacity(0.3))

                            // Camera Preview
                            Button(action: {
                                hasPhoto.toggle()
                            }) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.black.opacity(0.1))
                                    .aspectRatio(4/3, contentMode: .fit)
                                    .overlay(
                                        VStack(spacing: 12) {
                                            Image(systemName: hasPhoto ? "photo.fill" : "camera.fill")
                                                .font(.system(size: 50, weight: .black))
                                                .foregroundColor(.black.opacity(0.3))

                                            Text(hasPhoto ? "TAP TO RETAKE" : "TAP TO CAPTURE")
                                                .font(.system(size: 13, weight: .black))
                                                .foregroundColor(.black.opacity(0.4))
                                        }
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color.black, lineWidth: 2)
                                    )
                            }
                            .padding(16)
                        }
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 3)
                        )
                        .rotationEffect(.degrees(-1))
                        .shadow(color: .black, radius: 0, x: 6, y: 6)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                        // Goal Selection
                        VStack(spacing: 0) {
                            // Header
                            HStack {
                                Image(systemName: "target")
                                    .font(.system(size: 18, weight: .black))
                                    .foregroundColor(.black)

                                Text("SELECT GOAL")
                                    .font(.system(size: 14, weight: .black))
                                    .foregroundColor(.black)

                                Spacer()
                            }
                            .padding(12)
                            .background(Color.yellow.opacity(0.5))

                            // Goals List
                            VStack(spacing: 0) {
                                ForEach(availableGoals, id: \.self) { goal in
                                    Button(action: {
                                        selectedGoal = goal
                                    }) {
                                        HStack {
                                            Text(goal)
                                                .font(.system(size: 15, weight: .bold))
                                                .foregroundColor(.black)

                                            Spacer()

                                            if selectedGoal == goal {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .font(.system(size: 20))
                                                    .foregroundColor(.green)
                                            } else {
                                                Image(systemName: "circle")
                                                    .font(.system(size: 20))
                                                    .foregroundColor(.black.opacity(0.3))
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 14)
                                        .background(selectedGoal == goal ? Color.yellow.opacity(0.2) : Color.white)
                                    }

                                    if goal != availableGoals.last {
                                        Rectangle()
                                            .fill(Color.black)
                                            .frame(height: 2)
                                    }
                                }
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 3)
                        )
                        .rotationEffect(.degrees(1))
                        .shadow(color: .black, radius: 0, x: 6, y: 6)
                        .padding(.horizontal, 20)

                        // Message Section
                        VStack(spacing: 0) {
                            // Header
                            HStack {
                                Image(systemName: "text.bubble.fill")
                                    .font(.system(size: 18, weight: .black))
                                    .foregroundColor(.black)

                                Text("ADD MESSAGE (OPTIONAL)")
                                    .font(.system(size: 14, weight: .black))
                                    .foregroundColor(.black)

                                Spacer()
                            }
                            .padding(12)
                            .background(Color.cyan.opacity(0.3))

                            // Text Editor
                            ZStack(alignment: .topLeading) {
                                if message.isEmpty {
                                    Text("Share your thoughts...")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.black.opacity(0.3))
                                        .padding(.horizontal, 16)
                                        .padding(.top, 16)
                                }

                                TextEditor(text: $message)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.black)
                                    .frame(height: 100)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 8)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.white)
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 3)
                        )
                        .rotationEffect(.degrees(-0.5))
                        .shadow(color: .black, radius: 0, x: 6, y: 6)
                        .padding(.horizontal, 20)

                        // Submit Button
                        Button(action: {
                            // TODO: Submit check-in
                            dismiss()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 20, weight: .black))

                                Text("SUBMIT CHECK-IN")
                                    .font(.system(size: 16, weight: .black))
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.green)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 3)
                            )
                        }
                        .rotationEffect(.degrees(0.5))
                        .shadow(color: .black, radius: 0, x: 6, y: 6)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)

                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationTitle("New Check-In")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .black))
                            Text("CANCEL")
                                .font(.system(size: 14, weight: .black))
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.pink.opacity(0.5))
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.black, lineWidth: 2)
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    CreateCheckInView()
}
