import SwiftUI

struct WorkoutCard: View {
    let session: WorkoutSession
    var onTap: (() -> Void)?
    var onDuplicate: (() -> Void)?
    var onDelete: (() -> Void)?

    var body: some View {
        Button(action: { onTap?() }) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.neonGreen.opacity(0.1))
                        .frame(width: 48, height: 48)
                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.title3)
                        .foregroundStyle(Color.neonGreen)
                }

                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        Text((session.name.isEmpty ? "TREINO" : session.name).uppercased())
                            .font(.subheadline).fontWeight(.bold)
                            .foregroundStyle(.white)
                        if let template = session.templateName {
                            Text(template.uppercased())
                                .font(.system(size: 8)).fontWeight(.bold)
                                .padding(.horizontal, 6).padding(.vertical, 2)
                                .background(Color.neonBlue.opacity(0.15))
                                .clipShape(Capsule())
                                .foregroundStyle(Color.neonBlue)
                        }
                    }

                    Text(session.date.formattedRelative())
                        .font(.caption).foregroundStyle(.gray)

                    HStack(spacing: 10) {
                        Label("\(session.completedExercises) EX", systemImage: "dumbbell.fill")
                            .font(.system(size: 9)).fontWeight(.bold).foregroundStyle(.gray)
                        Label("\(session.totalSets) SÉRIES", systemImage: "list.bullet")
                            .font(.system(size: 9)).fontWeight(.bold).foregroundStyle(.gray)
                        if session.endTime != nil {
                            Label(session.duration.formattedDuration(), systemImage: "clock")
                                .font(.system(size: 9)).fontWeight(.bold).foregroundStyle(.gray)
                        }
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(String(format: "%.0f", session.totalVolume))
                        .font(.title3).fontWeight(.heavy)
                        .foregroundStyle(Color.neonGreen)
                    Text("KG")
                        .font(.caption2).fontWeight(.bold)
                        .foregroundStyle(.gray)
                }
            }
            .padding(14)
            .background(Color.gymCard)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.gymBorder, lineWidth: 1))
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
