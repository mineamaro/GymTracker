import SwiftUI

struct ExerciseRow: View {
    let exercise: Exercise
    var showFavorite: Bool = true
    var onTap: (() -> Void)?

    var body: some View {
        Button(action: { onTap?() }) {
            HStack(spacing: 14) {
                Image(systemName: exercise.imageName)
                    .font(.title3)
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.muscleGroupColor(exercise.muscleGroup))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 2) {
                    Text(exercise.name)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)

                    Text(exercise.muscleGroup)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if showFavorite {
                    Image(systemName: exercise.isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(exercise.isFavorite ? .red : .secondary)
                        .font(.caption)
                }

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 6)
        }
    }
}
