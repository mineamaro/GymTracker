import SwiftUI

struct GoalCard: View {
    let goal: Goal
    var onUpdate: ((Double) -> Void)?
    var onDelete: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: goal.iconName)
                    .font(.title3)
                    .foregroundStyle(goal.isCompleted ? .accentGreen : .accentBlue)

                VStack(alignment: .leading, spacing: 2) {
                    Text(goal.title)
                        .font(.body)
                        .fontWeight(.semibold)
                    if !goal.goalDescription.isEmpty {
                        Text(goal.goalDescription)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                if goal.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.accentGreen)
                        .font(.title3)
                }
            }

            ProgressBarView(progress: goal.progress, color: goal.isCompleted ? .accentGreen : .accentBlue)

            HStack {
                Text("\(String(format: "%.1f", goal.currentValue)) / \(String(format: "%.1f", goal.targetValue)) \(goal.unit)")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                if let deadline = goal.deadline {
                    Text("Meta: \(deadline.formattedShortDate())")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            if !goal.isCompleted, let onUpdate = onUpdate {
                HStack {
                    Button(action: { onUpdate(min(goal.currentValue + 1, goal.targetValue)) }) {
                        Label("+1", systemImage: "plus.circle")
                            .font(.caption)
                    }
                    .buttonStyle(.bordered)
                    .tint(.accentBlue)

                    Button(action: { onUpdate(goal.targetValue) }) {
                        Text("Concluir")
                            .font(.caption)
                    }
                    .buttonStyle(.bordered)
                    .tint(.accentGreen)
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
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
