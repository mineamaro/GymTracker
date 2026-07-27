import SwiftUI

extension Color {
    // Dark Base
    static let gymBackground = Color(red: 0.04, green: 0.04, blue: 0.08)
    static let gymCard = Color(red: 0.09, green: 0.09, blue: 0.16)
    static let gymCardLight = Color(red: 0.13, green: 0.13, blue: 0.20)
    static let gymBorder = Color(red: 0.18, green: 0.18, blue: 0.28)
    static let gymOverlay = Color(red: 0.22, green: 0.22, blue: 0.34)

    // Ultra Neon - mais vibrantes
    static let neonGreen = Color(red: 0.10, green: 1.00, blue: 0.50)
    static let neonBlue = Color(red: 0.10, green: 0.50, blue: 1.00)
    static let neonPink = Color(red: 1.00, green: 0.10, blue: 0.60)
    static let neonOrange = Color(red: 1.00, green: 0.40, blue: 0.00)
    static let neonPurple = Color(red: 0.60, green: 0.10, blue: 1.00)
    static let neonRed = Color(red: 1.00, green: 0.05, blue: 0.10)
    static let neonYellow = Color(red: 1.00, green: 0.80, blue: 0.00)
    static let neonCyan = Color(red: 0.00, green: 0.90, blue: 1.00)

    // Muscle group colors (ultra neon)
    static func muscleGroupColor(_ group: String) -> Color {
        switch group {
        case MuscleGroup.chest.rawValue: return .neonRed
        case MuscleGroup.back.rawValue: return .neonBlue
        case MuscleGroup.shoulders.rawValue: return .neonOrange
        case MuscleGroup.biceps.rawValue: return .neonPurple
        case MuscleGroup.triceps.rawValue: return .neonGreen
        case MuscleGroup.legs.rawValue: return .neonYellow
        case MuscleGroup.abdomen.rawValue: return .neonPink
        case MuscleGroup.cardio.rawValue: return .neonCyan
        default: return .gray
        }
    }
}

extension View {
    func neonGlow(color: Color, radius: CGFloat = 8) -> some View {
        self.shadow(color: color.opacity(0.6), radius: radius, x: 0, y: 0)
            .shadow(color: color.opacity(0.3), radius: radius * 2, x: 0, y: 0)
    }

    func gymGradient(_ color: Color) -> some View {
        self.background(
            LinearGradient(
                colors: [color.opacity(0.15), color.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}
