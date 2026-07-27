import SwiftUI

struct SimpleChartView: View {
    let data: [(Date, Double)]
    var title: String = ""
    var color: Color = .accentBlue
    var lineOnly: Bool = false

    private var maxValue: Double {
        data.map { $0.1 }.max() ?? 1
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !title.isEmpty {
                Text(title)
                    .font(.headline)
            }

            if data.isEmpty {
                Text("Sem dados suficientes")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
            } else {
                GeometryReader { geometry in
                    let width = geometry.size.width
                    let height = geometry.size.height - 20

                    ZStack(alignment: .bottomLeading) {
                        if lineOnly {
                            Path { path in
                                for (index, point) in data.enumerated() {
                                    let x = width * CGFloat(index) / CGFloat(max(data.count - 1, 1))
                                    let y = height * (1 - CGFloat(point.1 / maxValue))
                                    if index == 0 {
                                        path.move(to: CGPoint(x: x, y: y))
                                    } else {
                                        path.addLine(to: CGPoint(x: x, y: y))
                                    }
                                }
                            }
                            .stroke(color, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                        } else {
                            ZStack {
                                Path { path in
                                    for (index, point) in data.enumerated() {
                                        let x = width * CGFloat(index) / CGFloat(max(data.count - 1, 1))
                                        let y = height * (1 - CGFloat(point.1 / maxValue))
                                        if index == 0 {
                                            path.move(to: CGPoint(x: x, y: y))
                                        } else {
                                            path.addLine(to: CGPoint(x: x, y: y))
                                        }
                                    }
                                }
                                .stroke(color, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))

                                Path { path in
                                    for (index, point) in data.enumerated() {
                                        let x = width * CGFloat(index) / CGFloat(max(data.count - 1, 1))
                                        let y = height * (1 - CGFloat(point.1 / maxValue))
                                        if index == 0 {
                                            path.move(to: CGPoint(x: x, y: y))
                                            path.addLine(to: CGPoint(x: x, y: height))
                                        } else {
                                            path.addLine(to: CGPoint(x: x, y: y))
                                            path.addLine(to: CGPoint(x: x, y: height))
                                        }
                                    }
                                }
                                .fill(LinearGradient(colors: [color.opacity(0.3), color.opacity(0)], startPoint: .top, endPoint: .bottom))
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                        }

                        if data.count <= 8 {
                            ForEach(Array(data.enumerated()), id: \.offset) { index, point in
                                let x = width * CGFloat(index) / CGFloat(max(data.count - 1, 1))
                                let y = height * (1 - CGFloat(point.1 / maxValue))
                                Circle()
                                    .fill(color)
                                    .frame(width: 6, height: 6)
                                    .position(x: x, y: y)
                            }
                        }
                    }
                }
                .frame(height: 140)

                if data.count > 1 {
                    HStack {
                        Text(data.first?.0.formattedShortDate() ?? "")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(data.last?.0.formattedShortDate() ?? "")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
