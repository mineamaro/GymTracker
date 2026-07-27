import SwiftUI

struct ProgressBarView: View {
    let progress: Double
    var color: Color = .neonGreen
    var height: CGFloat = 10
    var showLabel: Bool = true

    var body: some View {
        VStack(spacing: 4) {
            if showLabel {
                HStack {
                    Text("\(Int(progress * 100))%")
                        .font(.caption).fontWeight(.bold)
                        .foregroundStyle(color)
                    Spacer()
                }
            }
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(Color.gymCardLight)
                        .frame(height: height)
                        .overlay(RoundedRectangle(cornerRadius: height / 2).stroke(Color.gymBorder, lineWidth: 1))

                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(color)
                        .frame(width: geometry.size.width * progress, height: height)
                        .shadow(color: color.opacity(0.4), radius: 4, x: 0, y: 0)
                        .animation(.spring(response: 0.6), value: progress)
                }
            }
            .frame(height: height)
        }
    }
}
