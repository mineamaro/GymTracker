import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    var color: Color = .neonBlue
    var trend: String? = nil

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)

            Text(value)
                .font(.title3).fontWeight(.heavy)
                .foregroundStyle(.white)
                .minimumScaleFactor(0.7)

            Text(title)
                .font(.caption2).fontWeight(.bold)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)

            if let trend = trend {
                Label(trend, systemImage: trend.hasPrefix("+") ? "arrow.up.right" : "arrow.down.right")
                    .font(.system(size: 9)).fontWeight(.bold)
                    .foregroundStyle(trend.hasPrefix("+") ? .neonGreen : .neonRed)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .padding(.horizontal, 8)
        .background(Color.gymCard)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.gymBorder, lineWidth: 1))
    }
}
