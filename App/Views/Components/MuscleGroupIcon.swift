import SwiftUI

struct MuscleGroupIcon: View {
    let muscleGroup: String
    var isSelected: Bool = false

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? Color.muscleGroupColor(muscleGroup) : Color.gymCard)
                    .frame(width: 54, height: 54)
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(
                        isSelected ? Color.muscleGroupColor(muscleGroup) : Color.gymBorder, lineWidth: 1.5))

                Image(systemName: MuscleGroup(rawValue: muscleGroup)?.iconName ?? "figure.strengthtraining.traditional")
                    .font(.title3)
                    .foregroundStyle(isSelected ? .white : Color.muscleGroupColor(muscleGroup))
            }

            Text(muscleGroup.uppercased())
                .font(.system(size: 8)).fontWeight(.bold)
                .foregroundStyle(isSelected ? .white : .gray)
                .lineLimit(1)
        }
        .frame(width: 72)
    }
}
