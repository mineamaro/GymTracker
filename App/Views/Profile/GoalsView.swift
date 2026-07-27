import SwiftUI

struct GoalsListView: View {
    @State private var viewModel: GoalsViewModel
    @Environment(\.dismiss) private var dismiss

    init(dataService: DataService) {
        _viewModel = State(initialValue: GoalsViewModel(dataService: dataService))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.goals, id: \.id) { goal in
                        GoalCard(
                            goal: goal,
                            onUpdate: { newValue in viewModel.updateProgress(goal, newValue: newValue) },
                            onDelete: { viewModel.deleteGoal(goal) }
                        )
                    }

                    if viewModel.goals.isEmpty {
                        EmptyStateView(
                            icon: "target",
                            title: "Nenhuma meta",
                            message: "Crie metas para acompanhar seu progresso!",
                            actionTitle: "Criar Meta",
                            action: { viewModel.showAddGoal = true }
                        )
                    }
                }
                .padding()
            }
            .background(Color(.systemBackground))
            .navigationTitle("Metas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Fechar") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { viewModel.showAddGoal = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showAddGoal) {
                addGoalSheet
            }
        }
    }

    private var addGoalSheet: some View {
        NavigationStack {
            Form {
                Section("Informações") {
                    TextField("Título", text: $viewModel.newGoalTitle)
                    TextField("Descrição", text: $viewModel.newGoalDescription, axis: .vertical)
                        .lineLimit(2...4)
                }

                Section("Meta") {
                    HStack {
                        Text("Valor Alvo")
                        Spacer()
                        TextField("Valor", value: $viewModel.newGoalTarget, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }

                    TextField("Unidade (kg, vezes, %)", text: $viewModel.newGoalUnit)

                    Picker("Categoria", selection: $viewModel.newGoalCategory) {
                        Text("Geral").tag("Geral")
                        Text("Peso").tag("Peso")
                        Text("Força").tag("Força")
                        Text("Frequência").tag("Frequência")
                        Text("Composição").tag("Composição")
                    }
                }

                Section("Prazo") {
                    DatePicker("Data Limite", selection: $viewModel.newGoalDeadline, displayedComponents: .date)
                }

                Section {
                    Button("Criar Meta") {
                        viewModel.addGoal()
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(viewModel.newGoalTitle.isEmpty || viewModel.newGoalTarget == 0)
                }
            }
            .navigationTitle("Nova Meta")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") { viewModel.showAddGoal = false }
                }
            }
        }
    }
}
