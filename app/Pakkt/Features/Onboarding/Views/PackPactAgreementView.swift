import SwiftUI

struct PackPactAgreementView: View {
    let onContinue: () -> Void
    
    @State private var hasAgreed: Bool = false
    @State private var scrollProgress: CGFloat = 0
    
    let pactContent = """
    THE PAKKT PACT
    
    By signing this pact, I acknowledge and agree to the following:
    
    COMMITMENT
    • I commit to achieving my stated goal(s) as defined in this pack
    • I will check in at the required times with valid proof
    • I will hold myself accountable to the standards set by this pack
    
    CONSEQUENCES
    • I accept that missing check-ins will result in the agreed consequences
    • I understand that repeated violations will lead to removal from the pack
    • I agree that pack decisions on violations are final
    
    COMMUNITY
    • I will support my pack members in their goals
    • I will participate in voting on pack decisions when required
    • I will maintain respectful communication with all pack members
    
    INTEGRITY
    • I will provide honest check-ins and will not falsify proof
    • I will accept responsibility for my actions
    • I will not make excuses for missed commitments
    
    UNDERSTANDING
    • I understand this is a social accountability system
    • I acknowledge that consequences are symbolic and self-imposed
    • I recognize that my participation is voluntary
    
    This pact represents my commitment to myself and my pack.
    I sign this knowing the weight of my word.
    """
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Header
            VStack(spacing: 16) {
                Text("THE PAKKT PACT")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Read carefully, this is real")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 32)
            
            // Pact Document
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(pactContent)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.primary)
                        .lineSpacing(4)
                        .padding(24)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .glassEffect(in: .rect(cornerRadius: 30))
            }
            .frame(maxHeight: 400)
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
            
            // Agreement Checkbox
            Button {
                hasAgreed.toggle()
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: hasAgreed ? "checkmark.square.fill" : "square")
                        .font(.system(size: 24))
                        .foregroundColor(hasAgreed ? .blue : .secondary)
                    
                    Text("I have read and agree to the Pakkt Pact")
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 24)
            
            Spacer()
            
            // Continue Button
            Button(action: onContinue) {
                Text("CONTINUE")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(hasAgreed ? .primary : .secondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .glassEffect(in: .rect(cornerRadius: 30))
            }
            .disabled(!hasAgreed)
            .opacity(hasAgreed ? 1.0 : 0.5)
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground))
    }
}

#Preview {
    PackPactAgreementView(onContinue: {})
}
