import SwiftUI

struct SetRow: View {
    let set: WorkoutSet
    var onDelete: (() -> Void)?

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(set.isPersonalRecord ? Color.neonOrange.opacity(0.15) : Color.gymCardLight)
                    .frame(width: 36, height: 36)
                Text("\(set.setNumber)")
                    .font(.callout).fontWeight(.bold)
                    .foregroundStyle(set.isPersonalRecord ? Color.neonOrange : .white)
            }

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Text("\(set.reps)").fontWeight(.bold).foregroundStyle(.white)
                        Text("REPS").font(.system(size: 9)).foregroundStyle(.gray)
                    }
                    .font(.subheadline)
                    HStack(spacing: 4) {
                        Text(String(format: "%.1f", set.weight)).fontWeight(.bold).foregroundStyle(.white)
                        Text("KG").font(.system(size: 9)).foregroundStyle(.gray)
                    }
                    .font(.subheadline)
                }

                if !set.notes.isEmpty {
                    Text(set.notes.uppercased())
                        .font(.system(size: 9)).foregroundStyle(.gray)
                }

                if set.isPersonalRecord {
                    Label("🔥 RECORDE PESSOAL!", systemImage: "flame.fill")
                        .font(.system(size: 9)).fontWeight(.bold)
                        .foregroundStyle(Color.neonOrange)
                }
            }

            Spacer()

            if set.setType != "Normal" {
                Text(set.setType.uppercased())
                    .font(.system(size: 8)).fontWeight(.bold)
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .background(Color.neonPurple.opacity(0.15))
                    .clipShape(Capsule())
                    .foregroundStyle(Color.neonPurple)
            }

            if let onDelete = onDelete {
                Button(action: onDelete) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.gray)
                        .font(.caption)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
