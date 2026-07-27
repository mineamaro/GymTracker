import SwiftUI

extension View {
    func gymCard() -> some View {
        self
            .padding()
            .background(Color.gymCard)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gymBorder, lineWidth: 1))
    }

    func gymButton(_ color: Color = .neonGreen) -> some View {
        self
            .fontWeight(.heavy)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(color.opacity(0.3), lineWidth: 1))
    }
}
