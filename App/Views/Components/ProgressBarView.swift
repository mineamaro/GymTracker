import SwiftUI

struct ProgressBarView: View {
    let progress: Double
    var color: Color = .accentGreen
    var height: CGFloat = 8
    var showLabel: Bool = true

    var body: some View {
        VStack(spacing: 4) {
            if showLabel {
                HStack {
                    Text("\(Int(progress * 100))%")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            }
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(Color(.systemGray5))
                        .frame(height: height)

                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(color)
                        .frame(width: geometry.size.width * progress, height: height)
                        .animation(.spring(response: 0.6), value: progress)
                }
            }
            .frame(height: height)
        }
    }
}
