import SwiftUI

struct HistoryView: View {
    @State private var viewModel: HistoryViewModel

    init(dataService: DataService) {
        _viewModel = State(initialValue: HistoryViewModel(dataService: dataService))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.gymBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        if viewModel.sessions.isEmpty {
                            EmptyStateView(
                                icon: "clock.arrow.circlepath",
                                title: "HISTÓRICO VAZIO",
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
            }
            .navigationTitle("📋 HISTÓRICO")
            .toolbarBackground(Color.gymCard, for: .navigationBar)
        }
    }

    private func sessionDetailView(_ session: WorkoutSession) -> some View {
        ZStack {
            Color.gymBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    VStack(spacing: 8) {
                        Text(session.date.formattedFullDate().uppercased())
                            .font(.title2).fontWeight(.heavy)
                            .foregroundStyle(.white)
                        HStack(spacing: 20) {
                            Label("⏱ \(session.duration.formattedDuration())", systemImage: "clock")
                                .font(.caption).fontWeight(.bold).foregroundStyle(.gray)
                            Label("⚡ \(String(format: "%.0f", session.totalVolume)) KG", systemImage: "scalemass")
                                .font(.caption).fontWeight(.bold).foregroundStyle(Color.neonGreen)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gymCard)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gymBorder, lineWidth: 1))

                    let grouped = Dictionary(grouping: session.sets.sorted(by: { $0.order < $1.order })) { $0.exerciseName }
                    ForEach(Array(grouped.keys.sorted()), id: \.self) { name in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(name.uppercased())
                                .font(.headline).fontWeight(.bold)
                                .foregroundStyle(.white)
                            ForEach(grouped[name]!.sorted(by: { $0.setNumber < $1.setNumber }), id: \.id) { set in
                                SetRow(set: set)
                            }
                        }
                        .padding()
                        .background(Color.gymCard)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.gymBorder, lineWidth: 1))
                    }
                }
                .padding()
            }
        }
        .navigationTitle("DETALHES")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.gymCard, for: .navigationBar)
    }
}
