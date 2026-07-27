import SwiftUI

struct PhotoCard: View {
    let photo: ProgressPhoto
    var onTap: (() -> Void)?
    var onCompare: (() -> Void)?
    var onDelete: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundStyle(Color.neonGreen)
                    .font(.caption)
                Text(photo.date.formattedFullDate().uppercased())
                    .font(.headline).fontWeight(.bold)
                    .foregroundStyle(.white)
                Spacer()
                HStack(spacing: 4) {
                    Text("\(String(format: "%.1f", photo.bodyWeight))")
                        .font(.title3).fontWeight(.heavy)
                        .foregroundStyle(Color.neonGreen)
                    Text("KG")
                        .font(.caption).fontWeight(.bold)
                        .foregroundStyle(.gray)
                }
            }

            HStack(spacing: 12) {
                ForEach(["front", "back", "side"], id: \.self) { angle in
                    VStack(spacing: 4) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gymCardLight)
                                .aspectRatio(0.75, contentMode: .fit)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gymBorder, lineWidth: 1))

                            Image(systemName: "person.fill")
                                .font(.largeTitle)
                                .foregroundStyle(.gray.opacity(0.3))
                        }
                        Text(angle == "front" ? "FRENTE" : angle == "back" ? "COSTAS" : "LATERAL")
                            .font(.system(size: 8)).fontWeight(.bold)
                            .foregroundStyle(.gray)
                    }
                }
            }

            if let fat = photo.bodyFat {
                HStack(spacing: 4) {
                    Image(systemName: "drop.fill")
                        .foregroundStyle(Color.neonOrange).font(.caption)
                    Text("\(String(format: "%.1f", fat))% GORDURA")
                        .font(.caption).fontWeight(.bold)
                        .foregroundStyle(Color.neonOrange)
                }
            }

            if !photo.notes.isEmpty {
                Text(photo.notes.uppercased())
                    .font(.caption).foregroundStyle(.gray)
            }

            HStack(spacing: 16) {
                if let onCompare = onCompare {
                    Button(action: onCompare) {
                        Label("⚖️ COMPARAR", systemImage: "rectangle.on.rectangle")
                            .font(.system(size: 10)).fontWeight(.bold)
                            .foregroundStyle(Color.neonBlue)
                    }
                }
                Spacer()
                if let onDelete = onDelete {
                    Button(role: .destructive, action: onDelete) {
                        Label("EXCLUIR", systemImage: "trash")
                            .font(.system(size: 10)).fontWeight(.bold)
                    }
                }
            }
        }
        .padding()
        .background(Color.gymCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gymBorder, lineWidth: 1))
    }
}
