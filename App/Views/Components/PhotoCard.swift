import SwiftUI

struct PhotoCard: View {
    let photo: ProgressPhoto
    var onTap: (() -> Void)?
    var onCompare: (() -> Void)?
    var onDelete: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(photo.date.formattedFullDate())
                    .font(.headline)
                Spacer()
                Text("\(String(format: "%.1f", photo.bodyWeight)) kg")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 12) {
                ForEach(["front", "back", "side"], id: \.self) { angle in
                    VStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray5))
                            .aspectRatio(0.75, contentMode: .fit)
                            .overlay {
                                Image(systemName: "person.fill")
                                    .font(.largeTitle)
                                    .foregroundStyle(.secondary)
                            }
                            .overlay(alignment: .bottom) {
                                Text(angle == "front" ? "Frente" : angle == "back" ? "Costas" : "Lateral")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                    .padding(.bottom, 4)
                            }
                    }
                }
            }

            if let fat = photo.bodyFat {
                HStack {
                    Label("\(String(format: "%.1f", fat))% gordura", systemImage: "drop.fill")
                        .font(.caption)
                        .foregroundStyle(Color.accentOrange)
                }
            }

            if !photo.notes.isEmpty {
                Text(photo.notes)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 16) {
                if let onCompare = onCompare {
                    Button(action: onCompare) {
                        Label("Comparar", systemImage: "rectangle.on.rectangle")
                            .font(.caption)
                    }
                }
                if let onDelete = onDelete {
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
