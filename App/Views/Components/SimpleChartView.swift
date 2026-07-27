import SwiftUI

struct SimpleChartView: View {
    let data: [(Date, Double)]
    var title: String = ""
    var color: Color = .neonBlue
    var lineOnly: Bool = false

    private var maxValue: Double {
        data.map { $0.1 }.max() ?? 1
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !title.isEmpty {
                Text(title)
                    .font(.headline).fontWeight(.bold)
                    .foregroundStyle(.white)
            }

            if data.isEmpty {
                Text("SEM DADOS SUFICIENTES")
                    .font(.subheadline).fontWeight(.bold)
                    .foregroundStyle(.gray)
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
                                    if index == 0 { path.move(to: CGPoint(x: x, y: y)) }
                                    else { path.addLine(to: CGPoint(x: x, y: y)) }
                                }
                            }
                            .stroke(color, style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                        } else {
                            ZStack {
                                Path { path in
                                    for (index, point) in data.enumerated() {
                                        let x = width * CGFloat(index) / CGFloat(max(data.count - 1, 1))
                                        let y = height * (1 - CGFloat(point.1 / maxValue))
                                        if index == 0 { path.move(to: CGPoint(x: x, y: y)) }
                                        else { path.addLine(to: CGPoint(x: x, y: y)) }
                                    }
                                }
                                .stroke(color, style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))

                                Path { path in
                                    for (index, point) in data.enumerated() {
                                        let x = width * CGFloat(index) / CGFloat(max(data.count - 1, 1))
                                        let y = height * (1 - CGFloat(point.1 / maxValue))
                                        if index == 0 { path.move(to: CGPoint(x: x, y: y)); path.addLine(to: CGPoint(x: x, y: height)) }
                                        else { path.addLine(to: CGPoint(x: x, y: y)); path.addLine(to: CGPoint(x: x, y: height)) }
                                    }
                                }
                                .fill(LinearGradient(colors: [color.opacity(0.25), color.opacity(0)], startPoint: .top, endPoint: .bottom))
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                        }

                        ForEach(Array(data.enumerated()), id: \.offset) { index, point in
                            let x = width * CGFloat(index) / CGFloat(max(data.count - 1, 1))
                            let y = height * (1 - CGFloat(point.1 / maxValue))
                            Circle()
                                .fill(color)
                                .frame(width: 7, height: 7)
                                .shadow(color: color.opacity(0.5), radius: 3)
                                .position(x: x, y: y)
                        }
                    }
                }
                .frame(height: 150)

                if data.count > 1 {
                    HStack {
                        Text(data.first?.0.formattedShortDate() ?? "")
                            .font(.system(size: 8)).foregroundStyle(.gray)
                        Spacer()
                        Text(data.last?.0.formattedShortDate() ?? "")
                            .font(.system(size: 8)).foregroundStyle(.gray)
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
