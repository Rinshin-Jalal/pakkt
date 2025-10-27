import SwiftUI

// MARK: - Step 20: Pack Rules
struct OnboardingStep20View: View {
    @State private var photoProofRequired = true
    @State private var beforeWindow = 15
    @State private var afterWindow = 15
    @State private var weekendPasses = false
    @State private var gracePeriod = 5
    let onContinue: () -> Void
    
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
                        Image(systemName: "scroll")
                            .font(.system(size: 48, weight: .regular))
                            .foregroundColor(.primary)
                        
                        Text("ESTABLISH PACK RULES")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                            .tracking(2.0)
                        
                        Text("Every great pack has clear rules. What are yours?")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    
                    // Photo Proof Rule
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "camera.fill")
                                .foregroundColor(.primary)
                            Text("PHOTO PROOF")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primary)
                                .tracking(1.0)
                        }
                        
                        Text("Require photo evidence for check-ins?")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 12) {
                            Button(action: { photoProofRequired = true }) {
                                Text("YES")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(photoProofRequired ? .primary : .secondary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(photoProofRequired ? Color.green.opacity(0.2) : Color.secondary.opacity(0.1))
                                    )
                            }
                            
                            Button(action: { photoProofRequired = false }) {
                                Text("NO")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(!photoProofRequired ? .primary : .secondary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(!photoProofRequired ? Color.red.opacity(0.2) : Color.secondary.opacity(0.1))
                                    )
                            }
                        }
                        
                        HStack(spacing: 6) {
                            Image(systemName: "lightbulb.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.yellow)
                            Text("Photos prevent cheating but add friction")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(20)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .padding(.horizontal, 20)
                    
                    // Check-in Window
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.primary)
                            Text("CHECK-IN WINDOW")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primary)
                                .tracking(1.0)
                        }
                        
                        Text("How flexible is timing?")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        VStack(spacing: 12) {
                            HStack {
                                Text("Before goal:")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            
                            HStack(spacing: 8) {
                                ForEach([0, 15, 30], id: \.self) { minutes in
                                    Button(action: { beforeWindow = minutes }) {
                                        Text("\(minutes) min")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(beforeWindow == minutes ? .primary : .secondary)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 8)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(beforeWindow == minutes ? Color.blue.opacity(0.2) : Color.secondary.opacity(0.1))
                                            )
                                    }
                                }
                            }
                            
                            HStack {
                                Text("After goal:")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            
                            HStack(spacing: 8) {
                                ForEach([0, 15, 30], id: \.self) { minutes in
                                    Button(action: { afterWindow = minutes }) {
                                        Text("\(minutes) min")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(afterWindow == minutes ? .primary : .secondary)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 8)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(afterWindow == minutes ? Color.blue.opacity(0.2) : Color.secondary.opacity(0.1))
                                            )
                                    }
                                }
                            }
                            
                            Text("Total window: \(beforeWindow + afterWindow) minutes")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    .padding(20)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .padding(.horizontal, 20)
                    
                    // Weekend Passes
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "calendar.badge.clock")
                                .foregroundColor(.primary)
                            Text("WEEKEND PASSES")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primary)
                                .tracking(1.0)
                        }
                        
                        Text("Allow skipping on weekends?")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 12) {
                            Button(action: { weekendPasses = true }) {
                                Text("ALLOW")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(weekendPasses ? .primary : .secondary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(weekendPasses ? Color.green.opacity(0.2) : Color.secondary.opacity(0.1))
                                    )
                            }
                            
                            Button(action: { weekendPasses = false }) {
                                Text("DENY")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(!weekendPasses ? .primary : .secondary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(!weekendPasses ? Color.red.opacity(0.2) : Color.secondary.opacity(0.1))
                                    )
                            }
                        }
                        
                        HStack(spacing: 6) {
                            Image(systemName: "lightbulb.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.yellow)
                            Text("Prevents burnout, but reduces consistency")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(20)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .padding(.horizontal, 20)
                    
                    // Grace Period
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "timer")
                                .foregroundColor(.primary)
                            Text("GRACE PERIOD")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primary)
                                .tracking(1.0)
                        }
                        
                        Text("How late is still \"on time\"?")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 8) {
                            ForEach([0, 5, 10, 15], id: \.self) { minutes in
                                Button(action: { gracePeriod = minutes }) {
                                    Text("\(minutes)min")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(gracePeriod == minutes ? .primary : .secondary)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(gracePeriod == minutes ? Color.orange.opacity(0.2) : Color.secondary.opacity(0.1))
                                        )
                                }
                            }
                        }
                        
                        Text("Selected: \(gracePeriod) minutes grace")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 6) {
                            Image(systemName: "lightbulb.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.yellow)
                            Text("Life happens, but be reasonable")
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
                    .padding(.horizontal, 20)
                    
                    Button(action: {
                        // Use default rules
                        photoProofRequired = true
                        beforeWindow = 15
                        afterWindow = 15
                        weekendPasses = false
                        gracePeriod = 5
                    }) {
                        Text("USE DEFAULT RULES")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                        .frame(height: 40)
                }
            }
        }
    }
}

#Preview {
    OnboardingStep20View(onContinue: {})
}
