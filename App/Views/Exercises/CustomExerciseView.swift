import SwiftUI

struct CustomExerciseView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var selectedGroup = MuscleGroup.chest.rawValue
    @State private var description = ""
    @State private var equipment = ""
    @State private var musclesWorked = ""

    var onSave: (String, String, String, String, String) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Informações Básicas") {
                    TextField("Nome do Exercício", text: $name)

                    Picker("Grupo Muscular", selection: $selectedGroup) {
                        ForEach(MuscleGroup.allCases, id: \.rawValue) { group in
                            HStack {
                                Image(systemName: group.iconName)
                                Text(group.rawValue)
                            }.tag(group.rawValue)
                        }
                    }
                }

                Section("Detalhes") {
                    TextField("Descrição", text: $description, axis: .vertical)
                        .lineLimit(3...6)

                    TextField("Equipamento", text: $equipment)

                    TextField("Músculos Trabalhados", text: $musclesWorked, axis: .vertical)
                        .lineLimit(2...4)
                }

                Section {
                    Button(action: save) {
                        Text("Criar Exercício")
                            .frame(maxWidth: .infinity)
                            .fontWeight(.semibold)
                    }
                    .disabled(name.isEmpty)
                }
            }
            .navigationTitle("Novo Exercício")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") { dismiss() }
                }
            }
        }
    }

    private func save() {
        guard !name.isEmpty else { return }
        onSave(name, selectedGroup, description, equipment, musclesWorked)
        dismiss()
    }
}
