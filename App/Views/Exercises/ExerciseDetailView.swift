import SwiftUI

struct ExerciseDetailView: View {
    let exercise: Exercise
    var dataService: DataService

    @State private var showHistory = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                heroSection
                infoSection
                historySection
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showHistory = true }) {
                    Image(systemName: "clock.arrow.circlepath")
                }
            }
        }
        .sheet(isPresented: $showHistory) {
            HistoryView(dataService: dataService)
        }
    }

    private var heroSection: some View {
        VStack(spacing: 12) {
            Image(systemName: exercise.imageName)
                .font(.system(size: 60))
                .foregroundStyle(.white)
                .frame(width: 120, height: 120)
                .background(Color.muscleGroupColor(exercise.muscleGroup))
                .clipShape(RoundedRectangle(cornerRadius: 24))

            Text(exercise.name)
                .font(.title)
                .fontWeight(.bold)

            Text(exercise.muscleGroup)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(Color.muscleGroupColor(exercise.muscleGroup).opacity(0.15))
                .foregroundStyle(Color.muscleGroupColor(exercise.muscleGroup))
                .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gymCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !exercise.exerciseDescription.isEmpty {
                infoRow(icon: "doc.text", title: "Descrição", value: exercise.exerciseDescription)
            }
            if !exercise.equipment.isEmpty {
                infoRow(icon: "gearshape", title: "Equipamento", value: exercise.equipment)
            }
            if !exercise.musclesWorked.isEmpty {
                infoRow(icon: "figure.strengthtraining.traditional", title: "Músculos Trabalhados", value: exercise.musclesWorked)
            }
        }
        .padding()
        .background(Color.gymCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func infoRow(icon: String, title: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(Color.neonBlue)
                .frame(width: 20)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.body)
            }
        }
    }

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Últimos Registros")
                .font(.headline)

            let history = dataService.loadHistory(for: exercise.id)
            if history.isEmpty {
                Text("Nenhum registro encontrado para este exercício.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding()
            } else {
                ForEach(history.prefix(5), id: \.0) { date, sets, _ in
                    HStack {
                        Text(date.formattedFullDate())
                            .font(.subheadline)
                        Spacer()
                        Text("\(sets) séries")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .background(Color.gymCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
