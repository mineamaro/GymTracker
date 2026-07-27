import SwiftUI

struct ProfileView: View {
    @State private var viewModel: ProfileViewModel
    @State private var showNotifications = false
    @State private var showGoals = false
    private let dataService: DataService

    init(dataService: DataService) {
        self.dataService = dataService
        _viewModel = State(initialValue: ProfileViewModel(dataService: dataService))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    profileHeader
                    profileForm
                    quickLinks
                }
                .padding()
            }
            .background(Color(.systemBackground))
            .navigationTitle("Perfil")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(viewModel.isEditing ? "Salvar" : "Editar") {
                        if viewModel.isEditing {
                            viewModel.saveProfile()
                        } else {
                            viewModel.isEditing = true
                        }
                    }
                }
            }
            .sheet(isPresented: $showNotifications) {
                NotificationsView()
            }
            .sheet(isPresented: $showGoals) {
                GoalsListView(dataService: dataService)
            }
        }
    }

    private var profileHeader: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(Color.accentBlue)
                .symbolRenderingMode(.hierarchical)

            if viewModel.isEditing {
                TextField("Nome", text: $viewModel.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
            } else {
                Text(viewModel.name.isEmpty ? "Sem nome" : viewModel.name)
                    .font(.title2)
                    .fontWeight(.bold)
            }

            if !viewModel.isEditing {
                Text(viewModel.objective)
                    .font(.subheadline)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(Color.accentGreen.opacity(0.15))
                    .foregroundStyle(Color.accentGreen)
                    .clipShape(Capsule())
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var profileForm: some View {
        VStack(spacing: 0) {
            profileRow("Idade", value: "\(viewModel.age)", isEditing: viewModel.isEditing) {
                if viewModel.isEditing {
                    Picker("", selection: $viewModel.age) {
                        ForEach(1...120, id: \.self) { age in
                            Text("\(age) anos").tag(age)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }

            Divider()

            profileRow("Altura", value: String(format: "%.1f cm", viewModel.height), isEditing: viewModel.isEditing) {
                if viewModel.isEditing {
                    HStack {
                        TextField("Altura", value: $viewModel.height, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("cm")
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Divider()

            profileRow("Peso", value: String(format: "%.1f kg", viewModel.weight), isEditing: viewModel.isEditing) {
                if viewModel.isEditing {
                    HStack {
                        TextField("Peso", value: $viewModel.weight, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("kg")
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Divider()

            profileRow("Objetivo", value: viewModel.objective, isEditing: viewModel.isEditing) {
                if viewModel.isEditing {
                    Picker("", selection: $viewModel.objective) {
                        ForEach(Objective.allCases, id: \.rawValue) { obj in
                            Text(obj.rawValue).tag(obj.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }

            Divider()

            profileRow("Meta", value: viewModel.goal.isEmpty ? "Adicionar meta" : viewModel.goal, isEditing: viewModel.isEditing) {
                if viewModel.isEditing {
                    TextField("Ex: Ganhar 5kg de massa magra", text: $viewModel.goal)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
        .padding()
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func profileRow(_ label: String, value: String, isEditing: Bool, @ViewBuilder editContent: () -> some View) -> some View {
        HStack {
            Text(label)
                .font(.body)
                .foregroundStyle(.primary)
            Spacer()
            if isEditing {
                editContent()
            } else {
                Text(value)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 8)
    }

    private var quickLinks: some View {
        VStack(spacing: 12) {
            Button(action: { showGoals = true }) {
                HStack {
                    Image(systemName: "target")
                        .foregroundStyle(Color.accentBlue)
                    Text("Metas")
                        .foregroundStyle(.primary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
                .padding()
                .background(Color.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Button(action: { showNotifications = true }) {
                HStack {
                    Image(systemName: "bell.fill")
                        .foregroundStyle(Color.accentOrange)
                    Text("Notificações")
                        .foregroundStyle(.primary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
                .padding()
                .background(Color.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}
