import SwiftUI

struct DiaryView: View {
    @State private var viewModel: DiaryViewModel

    init(dataService: DataService) {
        _viewModel = State(initialValue: DiaryViewModel(dataService: dataService))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    datePickerSection
                    entryFormSection
                    entriesListSection
                }
                .padding()
            }
            .background(Color(.systemBackground))
            .navigationTitle("Diário")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Salvar", action: viewModel.saveEntry)
                        .fontWeight(.semibold)
                }
            }
        }
    }

    private var datePickerSection: some View {
        VStack {
            HStack {
                Button(action: { changeDay(-1) }) {
                    Image(systemName: "chevron.left")
                }
                Text(viewModel.selectedDate.formattedFullDate())
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                Button(action: { changeDay(1) }) {
                    Image(systemName: "chevron.right")
                }
            }

            if viewModel.selectedDate.isSameDay(as: Date()) {
                Text("Hoje")
                    .font(.caption)
                    .foregroundStyle(Color.neonBlue)
            }
        }
        .padding()
        .background(Color.gymCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func changeDay(_ offset: Int) {
        if let newDate = Calendar.current.date(byAdding: .day, value: offset, to: viewModel.selectedDate) {
            viewModel.selectDate(newDate)
        }
    }

    private var entryFormSection: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Label("Humor", systemImage: "face.smiling")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Picker("Humor", selection: $viewModel.mood) {
                    ForEach(Mood.allCases, id: \.rawValue) { mood in
                        Text("\(mood.emoji) \(mood.rawValue)").tag(mood.rawValue)
                    }
                }
                .pickerStyle(.segmented)
            }

            VStack(alignment: .leading, spacing: 8) {
                Label("Energia", systemImage: "bolt.fill")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Picker("Energia", selection: $viewModel.energyLevel) {
                    ForEach(EnergyLevel.allCases, id: \.rawValue) { level in
                        Text(level.rawValue).tag(level.rawValue)
                    }
                }
                .pickerStyle(.segmented)
            }

            VStack(alignment: .leading, spacing: 4) {
                Label("Horas de Sono", systemImage: "moon.fill")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                HStack {
                    Slider(value: $viewModel.sleepHours, in: 0...12, step: 0.5)
                        .tint(Color.neonPurple)
                    Text("\(String(format: "%.1f", viewModel.sleepHours))h")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(width: 40)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Label("Alimentação", systemImage: "fork.knife")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                TextField("O que comeu hoje?", text: $viewModel.mealDescription, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(2...4)
            }

            VStack(alignment: .leading, spacing: 4) {
                Label("Dieta", systemImage: "leaf.fill")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                TextField("Notas sobre dieta...", text: $viewModel.dietNotes, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(2...4)
            }

            VStack(alignment: .leading, spacing: 4) {
                Label("Observações", systemImage: "note.text")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                TextField("Como foi seu dia?", text: $viewModel.observations, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(3...6)
            }
        }
        .padding()
        .background(Color.gymCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var entriesListSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Registros Anteriores")
                .font(.headline)

            ForEach(viewModel.entries.prefix(10), id: \.id) { entry in
                DiaryCard(entry: entry, onDelete: { viewModel.deleteEntry(entry) })
            }
        }
    }
}
