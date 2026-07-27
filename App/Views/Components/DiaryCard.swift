import SwiftUI

struct DiaryCard: View {
    let entry: DiaryEntry
    var onDelete: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(entry.date.formattedFullDate())
                    .font(.headline)
                Spacer()
                if let mood = Mood(rawValue: entry.mood) {
                    Text(mood.emoji)
                        .font(.title2)
                }
            }

            HStack(spacing: 16) {
                if !entry.energyLevel.isEmpty {
                    Label(entry.energyLevel, systemImage: EnergyLevel(rawValue: entry.energyLevel)?.iconName ?? "bolt")
                        .font(.caption)
                        .foregroundStyle(Color.accentBlue)
                }
                if entry.sleepHours > 0 {
                    Label("\(String(format: "%.1f", entry.sleepHours))h sono", systemImage: "moon.fill")
                        .font(.caption)
                        .foregroundStyle(Color.accentPurple)
                }
            }

            if !entry.mealDescription.isEmpty {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Alimentação")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(entry.mealDescription)
                        .font(.subheadline)
                }
            }

            if !entry.dietNotes.isEmpty {
                Text(entry.dietNotes)
                    .font(.subheadline)
            }

            if !entry.observations.isEmpty {
                Text(entry.observations)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .italic()
            }

            if let onDelete = onDelete {
                HStack {
                    Spacer()
                    Button(role: .destructive, action: onDelete) {
                        Label("Excluir", systemImage: "trash")
                            .font(.caption)
                    }
                }
            }
        }
        .padding()
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
