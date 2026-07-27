import SwiftUI

struct ActiveWorkoutView: View {
    @State private var viewModel: WorkoutViewModel
    @State private var showExercisePicker = false
    @State private var showTimer = false
    @State private var timerSeconds: Int = 90
    @State private var timerString = "00:00"
    @State private var timer: Timer? = nil
    @State private var workoutTimerString = "00:00"

    init(viewModel: WorkoutViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            workoutHeader
            timerBar
            exerciseList
            bottomBar
        }
        .onAppear { startWorkoutTimer() }
        .onDisappear { timer?.invalidate() }
        .sheet(isPresented: $showExercisePicker) {
            exercisePickerSheet
        }
        .sheet(isPresented: $viewModel.showAddSet) {
            AddSetView(viewModel: viewModel)
        }
    }

    private var workoutHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.activeSession?.name ?? "Treino")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Duração: \(workoutTimerString)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button(action: finishWorkout) {
                Text("Finalizar")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.accentRed)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
        }
        .padding()
        .background(Color.cardBackground)
    }

    private var timerBar: some View {
        HStack(spacing: 16) {
            Button(action: { showTimer = true }) {
                Label("Temporizador", systemImage: "timer")
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.accentOrange.opacity(0.15))
                    .foregroundStyle(.accentOrange)
                    .clipShape(Capsule())
            }

            if viewModel.isResting {
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundStyle(.accentOrange)
                    Text(formatRestTime(viewModel.restTimeRemaining))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.accentOrange)
                        .contentTransition(.numericText())
                    Button(action: viewModel.cancelRest) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.accentOrange.opacity(0.1))
                .clipShape(Capsule())
                .onAppear { startRestTimer() }
            }

            Spacer()

            Text("\(viewModel.activeSession?.totalSets ?? 0) séries")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    private var exerciseList: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(viewModel.groupedSets, id: \.exerciseId) { group in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "dumbbell.fill")
                                .foregroundStyle(.accentGreen)
                                .font(.caption)
                            Text(group.exerciseName)
                                .font(.headline)
                            Spacer()
                            Button(action: {
                                viewModel.addExerciseToSession(
                                    Exercise(name: group.exerciseName, muscleGroup: "")
                                )
                            }) {
                                Image(systemName: "plus.circle")
                                    .foregroundStyle(.accentBlue)
                            }
                        }

                        ForEach(group.sets, id: \.id) { set in
                            SetRow(set: set, onDelete: { viewModel.deleteSet(set) })
                        }
                    }
                    .padding()
                    .background(Color.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                }

                if viewModel.groupedSets.isEmpty {
                    EmptyStateView(
                        icon: "dumbbell.fill",
                        title: "Adicione Exercícios",
                        message: "Toque no botão abaixo para adicionar exercícios ao treino."
                    )
                }
            }
            .padding(.vertical)
        }
    }

    private var bottomBar: some View {
        HStack(spacing: 16) {
            Button(action: { showExercisePicker = true }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Adicionar Exercício")
                }
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentBlue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding()
        .background(.ultraThinMaterial)
    }

    private var exercisePickerSheet: some View {
        NavigationStack {
            List(viewModel.exercises) { exercise in
                Button(action: {
                    viewModel.addExerciseToSession(exercise)
                    showExercisePicker = false
                }) {
                    ExerciseRow(exercise: exercise, showFavorite: false)
                }
            }
            .navigationTitle("Escolher Exercício")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancelar") { showExercisePicker = false }
                }
            }
        }
    }

    private func startWorkoutTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            guard let session = viewModel.activeSession else { t.invalidate(); return }
            let elapsed = Date().timeIntervalSince(session.startTime)
            let hours = Int(elapsed) / 3600
            let minutes = (Int(elapsed) % 3600) / 60
            let seconds = Int(elapsed) % 60
            workoutTimerString = hours > 0
                ? String(format: "%d:%02d:%02d", hours, minutes, seconds)
                : String(format: "%02d:%02d", minutes, seconds)
        }
    }

    private func startRestTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            if viewModel.restTimeRemaining > 0 {
                viewModel.restTimeRemaining -= 1
            } else {
                viewModel.cancelRest()
                t.invalidate()
            }
        }
    }

    private func formatRestTime(_ seconds: Int) -> String {
        String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }

    private func finishWorkout() {
        viewModel.finishWorkout()
    }
}
