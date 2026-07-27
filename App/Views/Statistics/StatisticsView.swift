import SwiftUI

struct StatisticsView: View {
    @State private var viewModel: StatisticsViewModel

    init(dataService: DataService) {
        _viewModel = State(initialValue: StatisticsViewModel(dataService: dataService))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.gymBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        summaryGrid
                        weeklyVolumeChart
                        monthlyVolumeChart
                        mostTrainedSection
                        mostPerformedSection
                        maxWeightsSection
                    }
                    .padding()
                }
            }
            .navigationTitle("📊 ESTATÍSTICAS")
            .toolbarBackground(Color.gymCard, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: viewModel.loadStatistics) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundStyle(Color.neonGreen)
                    }
                }
            }
        }
    }

    private var summaryGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
            gymStatCard("TREINOS / SEMANA", "\(viewModel.totalWorkoutsWeek)", "calendar.badge.clock", .neonBlue)
            gymStatCard("TREINOS / MÊS", "\(viewModel.totalWorkoutsMonth)", "calendar", .neonGreen)
            gymStatCard("TREINOS / ANO", "\(viewModel.totalWorkoutsYear)", "yearly.calendar", .neonPurple)
            gymStatCard("DIAS SEGUIDOS", "\(viewModel.currentStreak)", "flame.fill", .neonOrange)
        }
    }

    private func gymStatCard(_ title: String, _ value: String, _ icon: String, _ color: Color) -> some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
            Text(value)
                .font(.title2).fontWeight(.heavy)
                .foregroundStyle(.white)
            Text(title)
                .font(.caption2).fontWeight(.bold)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.gymCard)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.gymBorder, lineWidth: 1))
    }

    private var weeklyVolumeChart: some View {
        SimpleChartView(data: viewModel.weeklyVolume, title: "📈 VOLUME SEMANAL (KG)", color: .neonGreen)
    }

    private var monthlyVolumeChart: some View {
        SimpleChartView(data: viewModel.monthlyVolume, title: "📈 VOLUME MENSAL (KG)", color: .neonBlue)
    }

    private var mostTrainedSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("🏆 GRUPOS MAIS TREINADOS")
                .font(.headline).fontWeight(.bold)
                .foregroundStyle(.white)

            ForEach(viewModel.mostTrainedGroups.prefix(5), id: \.0) { group, count in
                HStack {
                    Circle()
                        .fill(Color.muscleGroupColor(group))
                        .frame(width: 12, height: 12)
                    Text(group.uppercased())
                        .font(.subheadline).fontWeight(.semibold)
                        .foregroundStyle(.white)
                    Spacer()
                    HStack(spacing: 4) {
                        Text("\(count)").fontWeight(.bold)
                            .foregroundStyle(Color.neonGreen)
                        Text("TREINOS").font(.caption2)
                            .foregroundStyle(.gray)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(Color.gymCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gymBorder, lineWidth: 1))
    }

    private var mostPerformedSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("🔁 EXERCÍCIOS MAIS REALIZADOS")
                .font(.headline).fontWeight(.bold)
                .foregroundStyle(.white)

            ForEach(viewModel.mostPerformedExercises.prefix(5), id: \.0) { name, count in
                HStack {
                    Text(name.uppercased())
                        .font(.subheadline).fontWeight(.semibold)
                        .foregroundStyle(.white)
                    Spacer()
                    HStack(spacing: 4) {
                        Text("\(count)").fontWeight(.bold)
                            .foregroundStyle(Color.neonBlue)
                        Text("X").font(.caption2)
                            .foregroundStyle(.gray)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(Color.gymCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gymBorder, lineWidth: 1))
    }

    private var maxWeightsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("🏋️ PESO MÁXIMO POR EXERCÍCIO")
                .font(.headline).fontWeight(.bold)
                .foregroundStyle(.white)

            ForEach(viewModel.maxWeights.prefix(5), id: \.0) { name, weight in
                HStack {
                    Text(name.uppercased())
                        .font(.subheadline).fontWeight(.semibold)
                        .foregroundStyle(.white)
                    Spacer()
                    HStack(spacing: 4) {
                        Text(String(format: "%.1f", weight)).fontWeight(.bold)
                            .foregroundStyle(Color.neonGreen)
                        Text("KG").font(.caption2)
                            .foregroundStyle(.gray)
                    }
                }
                .padding(.vertical, 4)
            }

            if viewModel.maxWeights.isEmpty {
                Text("NENHUM PESO REGISTRADO AINDA.")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
        }
        .padding()
        .background(Color.gymCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gymBorder, lineWidth: 1))
    }
}
