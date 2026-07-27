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
                    .background(Color.muscleGroupColor(exercise.muscleGroup).opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.muscleGroupColor(exercise.muscleGroup).opacity(0.4), lineWidth: 1))

                VStack(alignment: .leading, spacing: 2) {
                    Text(exercise.name.uppercased())
                        .font(.subheadline).fontWeight(.bold)
                        .foregroundStyle(.white)
                    Text(exercise.muscleGroup.uppercased())
                        .font(.system(size: 9)).fontWeight(.bold)
                        .foregroundStyle(.gray)
                }

                Spacer()

                if showFavorite {
                    Image(systemName: exercise.isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(exercise.isFavorite ? Color.neonRed : .gray)
                        .font(.caption)
                }

                Image(systemName: "chevron.right")
                    .font(.caption).foregroundStyle(.gray)
            }
            .padding(.vertical, 6)
        }
    }
}
