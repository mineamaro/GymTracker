import SwiftUI

struct SetRow: View {
    let set: WorkoutSet
    var onDelete: (() -> Void)?

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(set.isPersonalRecord ? Color.accentOrange.opacity(0.2) : Color(.systemGray6))
                    .frame(width: 36, height: 36)

                Text("\(set.setNumber)")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(set.isPersonalRecord ? .accentOrange : .primary)
            }

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 8) {
                    Label("\(set.reps) reps", systemImage: "arrow.triangle.2.circlepath")
                        .font(.subheadline)
                    Label(String(format: "%.1f kg", set.weight), systemImage: "scalemass")
                        .font(.subheadline)
                }
                .foregroundStyle(.primary)

                if !set.notes.isEmpty {
                    Text(set.notes)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if set.isPersonalRecord {
                    Label("Recorde Pessoal!", systemImage: "flame.fill")
                        .font(.caption2)
                        .foregroundStyle(.accentOrange)
                }
            }

            Spacer()

            if set.setType != "Normal" {
                Text(set.setType)
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.accentPurple.opacity(0.15))
                    .clipShape(Capsule())
                    .foregroundStyle(.accentPurple)
            }

            if let onDelete = onDelete {
                Button(action: onDelete) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
