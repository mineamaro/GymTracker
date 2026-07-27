import SwiftUI

struct StatisticsView: View {
    @State private var viewModel: StatisticsViewModel

    init(dataService: DataService) {
        _viewModel = State(initialValue: StatisticsViewModel(dataService: dataService))
    }

    var body: some View {
        NavigationStack {
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
            .background(Color(.systemBackground))
            .navigationTitle("Estatísticas")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: viewModel.loadStatistics) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
    }

    private var summaryGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
            StatCard(title: "Treinos Essa Semana", value: "\(viewModel.totalWorkoutsWeek)", icon: "calendar.badge.clock", color: .accentBlue)
            StatCard(title: "Treinos Esse Mês", value: "\(viewModel.totalWorkoutsMonth)", icon: "calendar", color: .accentGreen)
            StatCard(title: "Treinos no Ano", value: "\(viewModel.totalWorkoutsYear)", icon: "yearly.calendar", color: .accentPurple)
            StatCard(title: "Dias Seguidos", value: "\(viewModel.currentStreak)", icon: "flame.fill", color: .accentOrange)
        }
    }

    private var weeklyVolumeChart: some View {
        SimpleChartView(data: viewModel.weeklyVolume, title: "Volume Semanal (kg)", color: .accentGreen)
    }

    private var monthlyVolumeChart: some View {
        SimpleChartView(data: viewModel.monthlyVolume, title: "Volume Mensal (kg)", color: .accentBlue)
    }

    private var mostTrainedSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Grupos Musculares Mais Treinados")
                .font(.headline)

            ForEach(viewModel.mostTrainedGroups.prefix(5), id: \.0) { group, count in
                HStack {
                    Circle()
                        .fill(Color.muscleGroupColor(group))
                        .frame(width: 10, height: 10)
                    Text(group)
                        .font(.subheadline)
                    Spacer()
                    Text("\(count) treinos")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var mostPerformedSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Exercícios Mais Realizados")
                .font(.headline)

            ForEach(viewModel.mostPerformedExercises.prefix(5), id: \.0) { name, count in
                HStack {
                    Text(name)
                        .font(.subheadline)
                    Spacer()
                    Text("\(count) vezes")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    private var maxWeightsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Peso Máximo por Exercício")
                .font(.headline)

            ForEach(viewModel.maxWeights.prefix(5), id: \.0) { name, weight in
                HStack {
                    Text(name)
                        .font(.subheadline)
                    Spacer()
                    Text("\(String(format: "%.1f", weight)) kg")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.accentGreen)
                }
            }

            if viewModel.maxWeights.isEmpty {
                Text("Nenhum peso registrado ainda.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
