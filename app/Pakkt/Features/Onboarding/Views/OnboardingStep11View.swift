import SwiftUI

// MARK: - Step 11: The Cost Analysis
struct OnboardingStep11View: View {
    @State private var showContent = false
    @State private var membershipCost: String = ""
    @State private var weeksSkipped: String = ""
    @State private var hoursWasted: String = ""
    @State private var showCalculation = false
    let goal: String
    let onContinue: (Double) -> Void
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case membership, weeks, hours
    }
    
    var totalCost: Double {
        let cost = Double(membershipCost) ?? 0
        let weeks = Double(weeksSkipped) ?? 0
        return cost * weeks
    }
    
    var totalHours: Double {
        let weeks = Double(weeksSkipped) ?? 0
        let hours = Double(hoursWasted) ?? 0
        return weeks * hours
    }
    
    var isComplete: Bool {
        !membershipCost.isEmpty && !weeksSkipped.isEmpty && !hoursWasted.isEmpty
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    Spacer().frame(height: 40)
                    
                    // Header
                    VStack(spacing: 16) {
                        Text("THE REAL COST")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.primary)
                            .tracking(2.0)
                        
                        Text("Every time you skip,\nyou're literally wasting...")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                        
                        Text("Let's add it up")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    .opacity(showContent ? 1 : 0)
                    
                    Spacer().frame(height: 32)
                    
                    // Input card
                    VStack(spacing: 24) {
                        // Membership cost
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 6) {
                                Text("MONTHLY COST")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.secondary)
                                    .tracking(1.0)
                                
                                Text("(per month)")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(.red)
                            }
                            
                            Text("Gym membership, subscription, etc.")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 12) {
                                Text("$")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                TextField("50", text: $membershipCost)
                                    .keyboardType(.decimalPad)
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.primary)
                                    .focused($focusedField, equals: .membership)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.secondary.opacity(0.1))
                            )
                        }
                        
                        // Weeks skipped
                        VStack(alignment: .leading, spacing: 8) {
                            Text("WEEKS SKIPPED")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.secondary)
                                .tracking(1.0)
                            
                            Text("How many weeks do you usually skip?")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 12) {
                                TextField("3", text: $weeksSkipped)
                                    .keyboardType(.numberPad)
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.primary)
                                    .focused($focusedField, equals: .weeks)
                                
                                Text("weeks")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.secondary.opacity(0.1))
                            )
                        }
                        
                        // Hours per week
                        VStack(alignment: .leading, spacing: 8) {
                            Text("HOURS PER WEEK")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.secondary)
                                .tracking(1.0)
                            
                            Text("Time you planned to spend each week")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 12) {
                                TextField("3", text: $hoursWasted)
                                    .keyboardType(.decimalPad)
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.primary)
                                    .focused($focusedField, equals: .hours)
                                
                                Text("hrs")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.secondary.opacity(0.1))
                            )
                        }
                        
                        // Calculate button
                        if !isComplete {
                            Button(action: {
                                focusedField = nil
                            }) {
                                Text("Calculate")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.secondary.opacity(0.1))
                                    )
                            }
                        }
                        
                        // Results
                        if isComplete {
                            VStack(spacing: 16) {
                                Divider()
                                
                                VStack(spacing: 12) {
                                    Text("TOTAL WASTED")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.secondary)
                                        .tracking(1.0)
                                    
                                    HStack(spacing: 8) {
                                        Image(systemName: "dollarsign.circle.fill")
                                            .font(.system(size: 24, weight: .semibold))
                                            .foregroundColor(.red)
                                        
                                        Text("$\(String(format: "%.0f", totalCost))")
                                            .font(.system(size: 36, weight: .bold))
                                            .foregroundColor(.red)
                                            .monospacedDigit()
                                    }
                                    
                                    HStack(spacing: 8) {
                                        Image(systemName: "clock.fill")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundColor(.red)
                                        
                                        Text("\(String(format: "%.0f", totalHours)) hours")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(.red)
                                            .monospacedDigit()
                                    }
                                }
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                            }
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 32)
                    .frame(maxWidth: 360)
                    .glassEffect(in: .rect(cornerRadius: 28))
                    .padding(.horizontal, 20)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 30)
                    
                    Spacer().frame(height: 80)
                }
            }
            
            // Continue button (fixed at bottom)
            VStack {
                Spacer()
                
                Button(action: {
                    onContinue(totalCost + totalHours)
                }) {
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
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .opacity(isComplete ? 1.0 : 0.5)
                .disabled(!isComplete)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                showContent = true
            }
        }
        .onChange(of: isComplete) { complete in
            if complete {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    showCalculation = true
                }
            }
        }
    }
}

#Preview {
    OnboardingStep11View(goal: "Go to gym", onContinue: { _ in })
}
