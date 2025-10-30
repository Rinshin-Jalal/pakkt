import SwiftUI

// MARK: - Goals Creation
struct GoalsCreationView: View {
    @State private var goalName: String = ""
    @State private var selectedHour = 6
    @State private var selectedMinute = 0
    @State private var selectedDays: Set<Int> = [1, 2, 3, 4, 5] // Mon-Fri
    @State private var frequency = "Daily"
    @FocusState private var isNameFieldFocused: Bool
    let onContinue: () -> Void
    
    let weekDays = ["S", "M", "T", "W", "T", "F", "S"]
    let frequencies = ["Daily", "Weekly", "Custom"]
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    Spacer()
                        .frame(height: 40)
                    
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "target")
                            .font(.system(size: 48, weight: .regular))
                            .foregroundColor(.primary)

                        Text("CREATE YOUR GOALS")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                            .tracking(2.0)

                        Text("Create your pack goals")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }

                    // Goal Name Input
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "pencil")
                                .foregroundColor(.primary)
                            Text("GOAL NAME")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primary)
                                .tracking(1.0)
                        }

                        Text("What goal will you be working towards?")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)

                        TextField("Enter goal name", text: $goalName)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.primary)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.secondary.opacity(0.1))
                            )
                            .focused($isNameFieldFocused)
                    }
                    .padding(20)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .padding(.horizontal, 20)

                    // Time Picker
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.primary)
                            Text("GOAL TIME")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primary)
                                .tracking(1.0)
                        }
                        
                        Text("What time do you want to complete your goal?")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 20) {
                            // Hour Picker
                            VStack(spacing: 8) {
                                Text("HOUR")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.secondary)
                                    .tracking(1.0)
                                
                                Picker("Hour", selection: $selectedHour) {
                                    ForEach(0..<24, id: \.self) { hour in
                                        Text("\(hour)")
                                            .tag(hour)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(width: 80, height: 120)
                                .clipped()
                            }
                            
                            Text(":")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.primary)
                            
                            // Minute Picker
                            VStack(spacing: 8) {
                                Text("MINUTE")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.secondary)
                                    .tracking(1.0)
                                
                                Picker("Minute", selection: $selectedMinute) {
                                    ForEach([0, 15, 30, 45], id: \.self) { minute in
                                        Text(String(format: "%02d", minute))
                                            .tag(minute)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(width: 80, height: 120)
                                .clipped()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        Text("Target: \(String(format: "%02d:%02d", selectedHour, selectedMinute))")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(20)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .padding(.horizontal, 20)
                    
                    // Day Selector
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.primary)
                            Text("ACTIVE DAYS")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primary)
                                .tracking(1.0)
                        }
                        
                        Text("Which days will you commit?")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 8) {
                            ForEach(0..<7, id: \.self) { index in
                                Button(action: {
                                    if selectedDays.contains(index) {
                                        selectedDays.remove(index)
                                    } else {
                                        selectedDays.insert(index)
                                    }
                                }) {
                                    Text(weekDays[index])
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(selectedDays.contains(index) ? .primary : .secondary)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(selectedDays.contains(index) ? Color.blue.opacity(0.2) : Color.secondary.opacity(0.1))
                                        )
                                }
                            }
                        }
                        
                        Text("\(selectedDays.count) days per week")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    .padding(20)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .padding(.horizontal, 20)
                    
                    // Frequency Selector
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "repeat")
                                .foregroundColor(.primary)
                            Text("FREQUENCY")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primary)
                                .tracking(1.0)
                        }
                        
                        Text("How often should this repeat?")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 12) {
                            ForEach(frequencies, id: \.self) { freq in
                                Button(action: { frequency = freq }) {
                                    Text(freq.uppercased())
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(frequency == freq ? .primary : .secondary)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(frequency == freq ? Color.purple.opacity(0.2) : Color.secondary.opacity(0.1))
                                        )
                                }
                            }
                        }
                    }
                    .padding(20)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .padding(.horizontal, 20)
                    
                    // Success Metrics Preview
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "chart.bar.fill")
                                .foregroundColor(.primary)
                            Text("SUCCESS METRICS")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primary)
                                .tracking(1.0)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Target time:")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("\(String(format: "%02d:%02d", selectedHour, selectedMinute))")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.primary)
                            }
                            
                            HStack {
                                Text("Days per week:")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("\(selectedDays.count)")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.primary)
                            }
                            
                            HStack {
                                Text("Frequency:")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(frequency)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.primary)
                            }
                        }
                        
                        HStack(spacing: 6) {
                            Image(systemName: "lightbulb.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.yellow)
                            Text("Pack context increases goal importance")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(20)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .padding(.horizontal, 20)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    // Continue Button
                    Button(action: onContinue) {
                        Text("CONTINUE")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.primary)
                            .tracking(1.5)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .glassEffect(in: .rect(cornerRadius: 30))
                    }
                    .disabled(goalName.isEmpty)
                    .opacity(goalName.isEmpty ? 0.5 : 1.0)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                        .frame(height: 40)
                }
            }
        }
        .onAppear {
            isNameFieldFocused = true
        }
    }
}

#Preview {
    GoalsCreationView(onContinue: {})
}
