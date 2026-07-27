import SwiftUI

extension Color {
    // Gym Theme - Neon / Dark Academia
    static let gymBackground = Color(red: 0.06, green: 0.06, blue: 0.10)
    static let gymCard = Color(red: 0.12, green: 0.12, blue: 0.18)
    static let gymCardLight = Color(red: 0.16, green: 0.16, blue: 0.22)
    static let gymBorder = Color(red: 0.20, green: 0.20, blue: 0.30)

    // Neon Accents
    static let neonGreen = Color(red: 0.20, green: 1.00, blue: 0.60)
    static let neonBlue = Color(red: 0.20, green: 0.60, blue: 1.00)
    static let neonPink = Color(red: 1.00, green: 0.20, blue: 0.60)
    static let neonOrange = Color(red: 1.00, green: 0.50, blue: 0.10)
    static let neonPurple = Color(red: 0.70, green: 0.20, blue: 1.00)
    static let neonRed = Color(red: 1.00, green: 0.10, blue: 0.20)
    static let neonYellow = Color(red: 1.00, green: 0.85, blue: 0.10)

    // Keep original accent names pointing to neon colors
    static let accentGreen = Color.neonGreen
    static let accentBlue = Color.neonBlue
    static let accentOrange = Color.neonOrange
    static let accentPurple = Color.neonPurple
    static let accentRed = Color.neonRed
    static let accentYellow = Color.neonYellow

    // Card background alias
    static let cardBackground = Color.gymCard

    // Muscle group colors (neon version)
    static func muscleGroupColor(_ group: String) -> Color {
        switch group {
        case MuscleGroup.chest.rawValue: return .neonRed
        case MuscleGroup.back.rawValue: return .neonBlue
        case MuscleGroup.shoulders.rawValue: return .neonOrange
        case MuscleGroup.biceps.rawValue: return .neonPurple
        case MuscleGroup.triceps.rawValue: return .neonGreen
        case MuscleGroup.legs.rawValue: return .neonYellow
        case MuscleGroup.abdomen.rawValue: return .neonPink
        case MuscleGroup.cardio.rawValue: return .teal
        default: return .gray
        }
    }
}
