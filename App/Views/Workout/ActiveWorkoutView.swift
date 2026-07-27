import SwiftUI

struct ActiveWorkoutView: View {
    @State private var viewModel: WorkoutViewModel
    @State private var showExercisePicker = false
    @State private var workoutTimerString = "00:00"

    init(viewModel: WorkoutViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color.gymBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                workoutHeader
                timerBar
                exerciseList
                bottomBar
            }
        }
        .onAppear { startWorkoutTimer() }
        .onDisappear { workoutTimerString = "00:00" }
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
                Text(viewModel.activeSession?.name ?? "TREINO")
                    .font(.title2).fontWeight(.heavy)
                    .foregroundStyle(.white)
                Text("⏱ \(workoutTimerString)")
                    .font(.subheadline).foregroundStyle(Color.neonGreen)
            }
            Spacer()
            Button(action: finishWorkout) {
                Text("FINALIZAR")
                    .fontWeight(.heavy).font(.caption)
                    .padding(.horizontal, 20).padding(.vertical, 10)
                    .background(Color.neonRed)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.neonRed.opacity(0.5), lineWidth: 1))
            }
        }
        .padding()
        .background(Color.gymCard)
    }

    private var timerBar: some View {
        HStack(spacing: 12) {
            Button(action: { startRestTimer() }) {
                Label("⏱ DESCANSO", systemImage: "timer")
                    .font(.caption).fontWeight(.bold)
                    .padding(.horizontal, 14).padding(.vertical, 8)
                    .background(Color.gymCardLight)
                    .foregroundStyle(Color.neonOrange)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.neonOrange.opacity(0.3), lineWidth: 1))
            }

            if viewModel.isResting {
                Text(formatRestTime(viewModel.restTimeRemaining))
                    .font(.title2).fontWeight(.bold)
                    .foregroundStyle(Color.neonOrange)
                    .contentTransition(.numericText())
                Button(action: viewModel.cancelRest) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.gray)
                }
            }

            Spacer()

            Text("⚡ \(viewModel.activeSession?.totalSets ?? 0) séries")
                .font(.caption).fontWeight(.bold)
                .foregroundStyle(Color.neonGreen)
        }
        .padding(.horizontal).padding(.vertical, 10)
        .background(Color.gymCard.opacity(0.5))
    }

    private var exerciseList: some View {
        ScrollView {
            VStack(spacing: 14) {
                if viewModel.groupedSets.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "dumbbell.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(Color.neonGreen.opacity(0.3))
                        Text("NENHUM EXERCÍCIO AINDA")
                            .font(.headline).fontWeight(.bold)
                            .foregroundStyle(.gray)
                        Text("Toque em + para adicionar")
                            .font(.subheadline).foregroundStyle(.gray.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 60)
                }

                ForEach(viewModel.groupedSets, id: \.exerciseId) { group in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "dumbbell.fill")
                                .foregroundStyle(Color.neonGreen)
                                .font(.caption)
                            Text(group.exerciseName.uppercased())
                                .font(.headline).fontWeight(.bold)
                                .foregroundStyle(.white)
                            Spacer()
                            Button(action: {
                                viewModel.addSetToExercicio(nome: group.exerciseName)
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title3)
                                    .foregroundStyle(Color.neonGreen)
                            }
                        }

                        ForEach(group.sets, id: \.id) { set in
                            SetRow(set: set, onDelete: { viewModel.deleteSet(set) })
                                .padding(.leading, 4)
                        }
                    }
                    .padding()
                    .background(Color.gymCardLight)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.gymBorder, lineWidth: 1))
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }

    private var bottomBar: some View {
        HStack(spacing: 16) {
            Button(action: { showExercisePicker = true }) {
                HStack {
                    Image(systemName: "plus.app.fill")
                    Text("ADICIONAR EXERCÍCIO")
                        .fontWeight(.heavy).font(.callout)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.neonGreen.opacity(0.15))
                .foregroundStyle(Color.neonGreen)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.neonGreen.opacity(0.3), lineWidth: 1))
            }
        }
        .padding()
        .background(Color.gymCard)
    }

    private var exercisePickerSheet: some View {
        NavigationStack {
            ZStack {
                Color.gymBackground.ignoresSafeArea()
                List(viewModel.exercises, id: \.id) { exercise in
                    Button(action: {
                        viewModel.addExerciseToSession(exercise)
                        showExercisePicker = false
                    }) {
                        ExerciseRow(exercise: exercise, showFavorite: false)
                    }
                    .listRowBackground(Color.gymCard)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("ESCOLHER EXERCÍCIO")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.gymCard, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancelar") { showExercisePicker = false }
                        .foregroundStyle(Color.neonGreen)
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
        viewModel.startRest(seconds: 90)
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
