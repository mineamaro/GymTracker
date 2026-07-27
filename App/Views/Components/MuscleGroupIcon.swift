import SwiftUI

struct MuscleGroupIcon: View {
    let muscleGroup: String
    var isSelected: Bool = false

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: MuscleGroup(rawValue: muscleGroup)?.iconName ?? "figure.strengthtraining.traditional")
                .font(.title3)
                .foregroundStyle(isSelected ? .white : Color.muscleGroupColor(muscleGroup))
                .frame(width: 48, height: 48)
                .background(isSelected ? Color.muscleGroupColor(muscleGroup) : Color.muscleGroupColor(muscleGroup).opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Text(muscleGroup)
                .font(.caption2)
                .foregroundStyle(isSelected ? .primary : .secondary)
                .lineLimit(1)
        }
        .frame(width: 70)
    }
}
