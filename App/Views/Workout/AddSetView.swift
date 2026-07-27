import SwiftUI

struct AddSetView: View {
    @State var viewModel: WorkoutViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                if let exercise = viewModel.selectedExercise {
                    VStack(spacing: 8) {
                        Image(systemName: exercise.imageName)
                            .font(.title)
                            .foregroundStyle(Color.muscleGroupColor(exercise.muscleGroup))

                        Text(exercise.name)
                            .font(.title3)
                            .fontWeight(.bold)

                        Text("Série \(viewModel.currentSetNumber)")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top)

                    VStack(spacing: 20) {
                        VStack(spacing: 8) {
                            HStack {
                                Text("Repetições")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("\(viewModel.currentReps)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            Slider(value: Binding(
                                get: { Double(viewModel.currentReps) },
                                set: { viewModel.currentReps = Int($0) }
                            ), in: 1...50, step: 1)
                            .tint(.accentBlue)
                        }

                        VStack(spacing: 8) {
                            HStack {
                                Text("Carga (kg)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(String(format: "%.1f", viewModel.currentWeight))
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            Slider(value: $viewModel.currentWeight, in: 0...300, step: 0.5)
                                .tint(.accentGreen)
                        }

                        HStack {
                            Text("Volume: \(String(format: "%.1f", Double(viewModel.currentReps) * viewModel.currentWeight)) kg")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }

                        TextField("Observações", text: $viewModel.currentNotes, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(2...4)
                    }
                    .padding()
                    .background(Color.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    HStack(spacing: 16) {
                        Button("Cancelar") {
                            dismiss()
                        }
                        .buttonStyle(.bordered)

                        Button("Salvar Série") {
                            viewModel.saveSet()
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.accentGreen)
                        .disabled(viewModel.currentReps == 0)
                    }
                }
            }
            .padding()
            .navigationTitle("Nova Série")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
