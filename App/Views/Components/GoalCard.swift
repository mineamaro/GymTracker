import SwiftUI

struct GoalCard: View {
    let goal: Goal
    var onUpdate: ((Double) -> Void)?
    var onDelete: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: goal.iconName)
                    .font(.title3)
                    .foregroundStyle(goal.isCompleted ? Color.neonGreen : Color.neonBlue)

                VStack(alignment: .leading, spacing: 2) {
                    Text(goal.title.uppercased())
                        .font(.body).fontWeight(.bold)
                        .foregroundStyle(.white)
                    if !goal.goalDescription.isEmpty {
                        Text(goal.goalDescription.uppercased())
                            .font(.caption).foregroundStyle(.gray)
                    }
                }

                Spacer()

                if goal.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.neonGreen)
                        .font(.title3)
                }
            }

            ProgressBarView(progress: goal.progress, color: goal.isCompleted ? .neonGreen : .neonBlue)

            HStack {
                Text("\(String(format: "%.1f", goal.currentValue)) / \(String(format: "%.1f", goal.targetValue)) \(goal.unit)")
                    .font(.caption).fontWeight(.bold)
                    .foregroundStyle(.gray)

                Spacer()

                if let deadline = goal.deadline {
                    Text("📅 \(deadline.formattedShortDate())")
                        .font(.system(size: 9)).fontWeight(.bold)
                        .foregroundStyle(.gray)
                }
            }

            if !goal.isCompleted, let onUpdate = onUpdate {
                HStack {
                    Button(action: { onUpdate(min(goal.currentValue + 1, goal.targetValue)) }) {
                        Label("+1", systemImage: "plus.circle")
                            .font(.caption).fontWeight(.bold)
                    }
                    .buttonStyle(.bordered)
                    .tint(Color.neonBlue)

                    Button(action: { onUpdate(goal.targetValue) }) {
                        Text("CONCLUIR")
                            .font(.caption).fontWeight(.bold)
                    }
                    .buttonStyle(.bordered)
                    .tint(Color.neonGreen)
                }
            }

            if let onDelete = onDelete {
                Button(role: .destructive, action: onDelete) {
                    Label("Excluir", systemImage: "trash")
                        .font(.caption)
                }
            }
        }
        .padding()
        .background(Color.gymCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gymBorder, lineWidth: 1))
    }
}
