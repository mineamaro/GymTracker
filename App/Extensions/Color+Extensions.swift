import SwiftUI

extension Color {
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let accentBlue = Color(red: 0.2, green: 0.5, blue: 0.9)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let accentPurple = Color(red: 0.6, green: 0.3, blue: 0.9)
    static let accentRed = Color(red: 0.9, green: 0.2, blue: 0.2)
    static let cardBackground = Color(.systemGray6)
    static let secondaryText = Color(.secondaryLabel)

    static func muscleGroupColor(_ group: String) -> Color {
        switch group {
        case MuscleGroup.chest.rawValue: return .red
        case MuscleGroup.back.rawValue: return .blue
        case MuscleGroup.shoulders.rawValue: return .orange
        case MuscleGroup.biceps.rawValue: return .purple
        case MuscleGroup.triceps.rawValue: return .green
        case MuscleGroup.legs.rawValue: return .yellow
        case MuscleGroup.abdomen.rawValue: return .pink
        case MuscleGroup.cardio.rawValue: return .teal
        default: return .gray
        }
    }
}

extension UIColor {
    static let accentGreen = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1)
}
