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
            Group {
                if viewModel.hasActiveWorkout {
                    ActiveWorkoutView(viewModel: viewModel)
                } else {
                    VStack(spacing: 0) {
                        startWorkoutButton
                        recentSessionsList
                    }
                }
            }
            .background(Color(.systemBackground))
            .navigationTitle("Treinos")
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
                Text("Iniciar Novo Treino")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accentGreen)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding()
    }

    private var recentSessionsList: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Treinos Recentes")
                    .font(.headline)
                    .padding(.horizontal)

                if viewModel.recentSessions.isEmpty {
                    EmptyStateView(
                        icon: "figure.strengthtraining.traditional",
                        title: "Nenhum treino ainda",
                        message: "Toque em 'Iniciar Novo Treino' para começar.",
                        actionTitle: "Iniciar Treino",
                        action: { showNewWorkout = true }
                    )
                } else {
                    ForEach(viewModel.recentSessions) { session in
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
        NavigationStack {
            VStack(spacing: 20) {
                Text("Novo Treino")
                    .font(.title2)
                    .fontWeight(.bold)

                TextField("Nome do treino", text: $newWorkoutName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                HStack(spacing: 16) {
                    Button("Cancelar") {
                        showNewWorkout = false
                    }
                    .buttonStyle(.bordered)

                    Button("Iniciar") {
                        let name = newWorkoutName.isEmpty ? "Treino \(Date().formattedShortDate())" : newWorkoutName
                        viewModel.startNewWorkout(name: name)
                        newWorkoutName = ""
                        showNewWorkout = false
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.accentGreen)
                }
            }
            .padding()
            .presentationDetents([.height(200)])
        }
    }
}
