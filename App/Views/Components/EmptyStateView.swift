import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundStyle(.gray.opacity(0.3))

            Text(title)
                .font(.headline).fontWeight(.bold)
                .foregroundStyle(.gray)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.gray.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.caption).fontWeight(.heavy)
                        .padding(.horizontal, 24).padding(.vertical, 12)
                        .background(Color.neonGreen.opacity(0.15))
                        .foregroundStyle(Color.neonGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.neonGreen.opacity(0.3), lineWidth: 1))
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gymCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gymBorder, lineWidth: 1))
    }
}
