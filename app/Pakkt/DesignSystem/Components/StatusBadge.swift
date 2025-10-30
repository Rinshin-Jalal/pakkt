import SwiftUI

struct StatusBadge: View {
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
            
        }
        .foregroundColor(color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(color.opacity(0.1))
        )
    }
}

#Preview {
    VStack(spacing: 12) {
        StatusBadge(icon: "checkmark.circle.fill", color: .green)
        StatusBadge(icon: "clock.fill", color: .orange)
        StatusBadge(icon: "exclamationmark.triangle.fill", color: .red)
    }
    .padding()
}
