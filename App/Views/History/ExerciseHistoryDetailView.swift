import SwiftUI

struct ExerciseHistoryDetailView: View {
    let exercise: Exercise
    let dataService: DataService

    @State private var historyData: [(Date, Int, String)] = []
    @State private var volumeData: [(Date, Double)] = []
    @State private var weightData: [(Date, Double)] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                SimpleChartView(data: volumeData, title: "Evolução do Volume", color: .accentGreen)

                SimpleChartView(data: weightData, title: "Evolução da Carga Máxima", color: .accentBlue)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Histórico Completo")
                        .font(.headline)

                    if historyData.isEmpty {
                        Text("Nenhum registro encontrado.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(historyData, id: \.0) { date, sets, details in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(date.formattedFullDate())
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Text("\(sets) séries")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Text(details)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                            if date != historyData.last?.0 {
                                Divider()
                            }
                        }
                    }
                }
                .padding()
                .background(Color.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            let raw = dataService.loadHistory(for: exercise.id)
            historyData = raw.map { ($0.0, $0.1, $0.2) }
            volumeData = dataService.volumeHistory(for: exercise.id)
            let allSets = dataService.allSetsForExercise(exercise.id)
            let groupedByDate = Dictionary(grouping: allSets) { Calendar.current.startOfDay(for: $0.0) }
            weightData = groupedByDate.map { (date, sets) in
                (date, sets.map { $0.2 }.max() ?? 0)
            }.sorted { $0.0 < $1.0 }
        }
    }
}
