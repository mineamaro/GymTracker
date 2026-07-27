import SwiftUI

struct PhotoComparisonView: View {
    let oldPhoto: ProgressPhoto
    let newPhoto: ProgressPhoto
    var onDismiss: (() -> Void)?

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack {
                    Text(oldPhoto.date.formattedShortDate())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    photoPlaceholder
                        .overlay(alignment: .bottom) {
                            Text("\(String(format: "%.1f", oldPhoto.bodyWeight)) kg")
                                .font(.caption2)
                                .padding(4)
                                .background(.ultraThinMaterial)
                        }
                }

                Image(systemName: "arrow.right")
                    .font(.title2)
                    .foregroundStyle(.accentBlue)

                VStack {
                    Text(newPhoto.date.formattedShortDate())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    photoPlaceholder
                        .overlay(alignment: .bottom) {
                            Text("\(String(format: "%.1f", newPhoto.bodyWeight)) kg")
                                .font(.caption2)
                                .padding(4)
                                .background(.ultraThinMaterial)
                        }
                }
            }

            statsComparison

            if let onDismiss = onDismiss {
                Button("Fechar", action: onDismiss)
                    .buttonStyle(.bordered)
            }
        }
        .padding()
    }

    private var photoPlaceholder: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(.systemGray5))
            .aspectRatio(0.75, contentMode: .fit)
            .overlay {
                Image(systemName: "person.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.secondary)
            }
    }

    private var statsComparison: some View {
        HStack(spacing: 30) {
            VStack(spacing: 4) {
                Text("Peso")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("\(String(format: "%.1f", oldPhoto.bodyWeight)) kg")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Image(systemName: "arrow.right")
                    .font(.caption)
                    .foregroundStyle(.accentGreen)
                Text("\(String(format: "%.1f", newPhoto.bodyWeight)) kg")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.accentGreen)
            }

            if let oldFat = oldPhoto.bodyFat, let newFat = newPhoto.bodyFat {
                VStack(spacing: 4) {
                    Text("Gordura")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(String(format: "%.1f", oldFat))%")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Image(systemName: "arrow.right")
                        .font(.caption)
                    Text("\(String(format: "%.1f", newFat))%")
                        .font(.title3)
                        .fontWeight(.bold)
                }
            }
        }
    }
}
