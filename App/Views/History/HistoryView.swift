import SwiftUI

struct HistoryView: View {
    @State private var viewModel: HistoryViewModel

    init(dataService: DataService) {
        _viewModel = State(initialValue: HistoryViewModel(dataService: dataService))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    if viewModel.sessions.isEmpty {
                        EmptyStateView(
                            icon: "clock.arrow.circlepath",
                            title: "Histórico vazio",
                            message: "Complete treinos para ver seu histórico aqui."
                        )
                    } else {
                        ForEach(viewModel.sessions, id: \.id) { session in
                            NavigationLink(destination: sessionDetailView(session)) {
                                WorkoutCard(
                                    session: session,
                                    onDuplicate: { viewModel.duplicateSession(session) },
                                    onDelete: { viewModel.deleteSession(session) }
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
            .background(Color(.systemBackground))
            .navigationTitle("Histórico")
        }
    }

    private func sessionDetailView(_ session: WorkoutSession) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    Text(session.date.formattedFullDate())
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Duração: \(session.duration.formattedDuration())")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("Volume total: \(String(format: "%.0f", session.totalVolume)) kg")
                        .font(.subheadline)
                        .foregroundStyle(Color.accentGreen)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                let grouped = Dictionary(grouping: session.sets.sorted(by: { $0.order < $1.order })) { $0.exerciseName }
                ForEach(Array(grouped.keys.sorted()), id: \.self) { name in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(name)
                            .font(.headline)
                        ForEach(grouped[name]!.sorted(by: { $0.setNumber < $1.setNumber }), id: \.id) { set in
                            SetRow(set: set)
                        }
                    }
                    .padding()
                    .background(Color.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .navigationTitle("Detalhes do Treino")
        .navigationBarTitleDisplayMode(.inline)
    }
}
