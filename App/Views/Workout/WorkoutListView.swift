import SwiftUI

struct WorkoutListView: View {
    @State private var viewModel: WorkoutViewModel
    @State private var showNewWorkout = false
    @State private var newWorkoutName = ""

    init(dataService: DataService) {
        _viewModel = State(initialValue: WorkoutViewModel(dataService: dataService))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.gymBackground.ignoresSafeArea()

                if viewModel.hasActiveWorkout {
                    ActiveWorkoutView(viewModel: viewModel)
                } else {
                    VStack(spacing: 0) {
                        startWorkoutButton
                        recentSessionsList
                    }
                }
            }
            .navigationTitle("💪 TREINOS")
            .toolbarBackground(Color.gymCard, for: .navigationBar)
            .sheet(isPresented: $showNewWorkout) {
                newWorkoutSheet
            }
            .onAppear { viewModel.loadData() }
        }
    }

    private var startWorkoutButton: some View {
        Button(action: { showNewWorkout = true }) {
            HStack {
                Image(systemName: "play.fill")
                Text("INICIAR NOVO TREINO")
                    .fontWeight(.heavy)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(Color.neonGreen.opacity(0.15))
            .foregroundStyle(Color.neonGreen)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.neonGreen.opacity(0.3), lineWidth: 1))
        }
        .padding()
    }

    private var recentSessionsList: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("📋 TREINOS RECENTES")
                    .font(.headline).fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding(.horizontal)

                if viewModel.recentSessions.isEmpty {
                    EmptyStateView(
                        icon: "figure.strengthtraining.traditional",
                        title: "NENHUM TREINO AINDA",
                        message: "Toque em 'Iniciar Novo Treino' para começar.",
                        actionTitle: "INICIAR TREINO",
                        action: { showNewWorkout = true }
                    )
                } else {
                    ForEach(viewModel.recentSessions, id: \.id) { session in
                        WorkoutCard(
                            session: session,
                            onTap: { viewModel.activateSession(session) },
                            onDuplicate: { viewModel.duplicateSession(session) },
                            onDelete: { viewModel.deleteSession(session) }
                        )
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
    }

    private var newWorkoutSheet: some View {
        ZStack {
            Color.gymBackground.ignoresSafeArea()
            VStack(spacing: 24) {
                Text("🏋️ NOVO TREINO")
                    .font(.title2).fontWeight(.heavy)
                    .foregroundStyle(.white)

                TextField("NOME DO TREINO", text: $newWorkoutName)
                    .padding(14)
                    .background(Color.gymCard)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .foregroundStyle(.white)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gymBorder, lineWidth: 1))
                    .padding(.horizontal)

                HStack(spacing: 16) {
                    Button("CANCELAR") {
                        showNewWorkout = false
                    }
                    .fontWeight(.bold).font(.caption)
                    .padding(.horizontal, 24).padding(.vertical, 12)
                    .background(Color.gymCard)
                    .foregroundStyle(.gray)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.gymBorder, lineWidth: 1))

                    Button("INICIAR") {
                        let name = newWorkoutName.isEmpty ? "TREINO \(Date().formattedShortDate().uppercased())" : newWorkoutName.uppercased()
                        viewModel.startNewWorkout(name: name)
                        newWorkoutName = ""
                        showNewWorkout = false
                    }
                    .fontWeight(.heavy).font(.caption)
                    .padding(.horizontal, 24).padding(.vertical, 12)
                    .background(Color.neonGreen.opacity(0.15))
                    .foregroundStyle(Color.neonGreen)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.neonGreen.opacity(0.3), lineWidth: 1))
                }
            }
            .padding()
            .presentationDetents([.height(220)])
        }
    }
}
