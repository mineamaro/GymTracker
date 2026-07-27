import SwiftUI

struct WorkoutCard: View {
    let session: WorkoutSession
    var onTap: (() -> Void)?
    var onDuplicate: (() -> Void)?
    var onDelete: (() -> Void)?

    var body: some View {
        Button(action: { onTap?() }) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.accentGreen.opacity(0.15))
                        .frame(width: 50, height: 50)

                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.title3)
                        .foregroundStyle(Color.accentGreen)
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(session.name.isEmpty ? "Treino" : session.name)
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)

                        if let template = session.templateName {
                            Text(template)
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.accentBlue.opacity(0.15))
                                .clipShape(Capsule())
                                .foregroundStyle(Color.accentBlue)
                        }
                    }

                    Text(session.date.formattedRelative())
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 12) {
                        Label("\(session.completedExercises) ex", systemImage: "dumbbell.fill")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Label("\(session.totalSets) séries", systemImage: "list.bullet")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        if session.endTime != nil {
                            Label(session.duration.formattedDuration(), systemImage: "clock")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(String(format: "%.0f", session.totalVolume))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.accentGreen)
                    Text("kg")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .contextMenu {
            if let onDuplicate = onDuplicate {
                Button(action: onDuplicate) {
                    Label("Duplicar", systemImage: "doc.on.doc")
                }
            }
            if let onDelete = onDelete {
                Button(role: .destructive, action: onDelete) {
                    Label("Excluir", systemImage: "trash")
                }
            }
        }
    }
}
