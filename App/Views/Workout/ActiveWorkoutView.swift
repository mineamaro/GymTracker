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
                HStack(spacing: 6) {
                    Image(systemName: "clock.fill")
                        .font(.caption2).foregroundStyle(Color.neonGreen)
                    Text(workoutTimerString)
                        .font(.subheadline).fontWeight(.bold)
                        .foregroundStyle(Color.neonGreen)
                        .contentTransition(.numericText())
                }
            }
            Spacer()
            Button(action: finishWorkout) {
                Text("FINALIZAR")
                    .font(.caption).fontWeight(.heavy)
                    .padding(.horizontal, 20).padding(.vertical, 10)
                    .background(Color.neonRed)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                    .neonGlow(color: .neonRed, radius: 6)
            }
        }
        .padding()
        .background(Color.gymCard)
        .overlay(Rectangle().frame(height: 1).foregroundStyle(Color.gymBorder), alignment: .bottom)
    }

    private var timerBar: some View {
        HStack(spacing: 12) {
            Button(action: { startRestTimer() }) {
                HStack(spacing: 6) {
                    Image(systemName: "timer")
                        .font(.caption)
                    Text("DESCANSO")
                        .font(.caption).fontWeight(.bold)
                }
                .padding(.horizontal, 14).padding(.vertical, 8)
                .background(Color.gymCardLight)
                .foregroundStyle(Color.neonOrange)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color.neonOrange.opacity(0.3), lineWidth: 1))
            }

            if viewModel.isResting {
                HStack(spacing: 6) {
                    Image(systemName: "clock.fill")
                        .font(.caption).foregroundStyle(Color.neonOrange)
                    Text(formatRestTime(viewModel.restTimeRemaining))
                        .font(.title3).fontWeight(.bold)
                        .foregroundStyle(Color.neonOrange)
                        .contentTransition(.numericText())
                        .monospacedDigit()
                    Button(action: viewModel.cancelRest) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray).font(.caption)
                    }
                }
                .padding(.horizontal, 12).padding(.vertical, 6)
                .background(Color.neonOrange.opacity(0.1))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color.neonOrange.opacity(0.2), lineWidth: 1))
            }

            Spacer()

            HStack(spacing: 4) {
                Text("⚡")
                    .font(.caption)
                Text("\(viewModel.activeSession?.totalSets ?? 0)")
                    .font(.subheadline).fontWeight(.bold).foregroundStyle(Color.neonGreen)
                Text("SÉRIES")
                    .font(.system(size: 9)).fontWeight(.bold).foregroundStyle(.gray)
            }
        }
        .padding(.horizontal).padding(.vertical, 10)
        .background(Color.gymCard.opacity(0.6))
    }

    private var exerciseList: some View {
        ScrollView {
            VStack(spacing: 14) {
                if viewModel.groupedSets.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "dumbbell.fill")
                            .font(.system(size: 54))
                            .foregroundStyle(Color.neonGreen.opacity(0.2))
                            .neonGlow(color: .neonGreen, radius: 12)
                        Text("NENHUM EXERCÍCIO")
                            .font(.title3).fontWeight(.heavy)
                            .foregroundStyle(.gray)
                        Text("Toque no botão abaixo para adicionar")
                            .font(.subheadline).foregroundStyle(.gray.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 80)
                }

                ForEach(viewModel.groupedSets, id: \.exerciseId) { group in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "dumbbell.fill")
                                .font(.caption).foregroundStyle(Color.neonGreen)
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
                                    .neonGlow(color: .neonGreen, radius: 4)
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
                HStack(spacing: 8) {
                    Image(systemName: "plus.app.fill")
                    Text("ADICIONAR EXERCÍCIO")
                        .fontWeight(.heavy).font(.callout)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.neonGreen.opacity(0.12))
                .foregroundStyle(Color.neonGreen)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.neonGreen.opacity(0.25), lineWidth: 1))
            }
        }
        .padding()
        .background(Color.gymCard)
        .overlay(Rectangle().frame(height: 1).foregroundStyle(Color.gymBorder), alignment: .top)
    }

    // ═══════════════════════════════════════
    // EXERCISE PICKER - CORRIGIDO
    // ═══════════════════════════════════════
    private var exercisePickerSheet: some View {
        NavigationStack {
            ZStack {
                Color.gymBackground.ignoresSafeArea()

                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.exercises, id: \.id) { exercise in
                            ExerciseRow(exercise: exercise, showFavorite: false)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    viewModel.addExerciseToSession(exercise)
                                    showExercisePicker = false
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 6)

                            Divider()
                                .background(Color.gymBorder.opacity(0.5))
                                .padding(.leading, 70)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("ESCOLHER EXERCÍCIO")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.gymCard, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancelar") { showExercisePicker = false }
                        .fontWeight(.bold).foregroundStyle(Color.neonGreen)
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
            withAnimation(.snappy) {
                workoutTimerString = hours > 0
                    ? String(format: "%d:%02d:%02d", hours, minutes, seconds)
                    : String(format: "%02d:%02d", minutes, seconds)
            }
        }
    }

    private func startRestTimer() {
        viewModel.startRest(seconds: 90)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            withAnimation(.snappy) {
                if viewModel.restTimeRemaining > 0 {
                    viewModel.restTimeRemaining -= 1
                } else {
                    viewModel.cancelRest()
                    t.invalidate()
                }
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
