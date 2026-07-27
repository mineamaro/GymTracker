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
            ZStack {
                Color.gymBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        profileHeader
                        profileForm
                        quickLinks
                    }
                    .padding()
                }
            }
            .navigationTitle("👤 PERFIL")
            .toolbarBackground(Color.gymCard, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(viewModel.isEditing ? "SALVAR" : "EDITAR") {
                        if viewModel.isEditing {
                            viewModel.saveProfile()
                        } else {
                            viewModel.isEditing = true
                        }
                    }
                    .fontWeight(.bold).font(.caption)
                    .foregroundStyle(Color.neonGreen)
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
                .foregroundStyle(Color.neonGreen)
                .symbolRenderingMode(.hierarchical)

            if viewModel.isEditing {
                TextField("", text: $viewModel.name)
                    .font(.title2).fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                    .padding(10)
                    .background(Color.gymCardLight)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .foregroundStyle(.white)
            } else {
                Text(viewModel.name.isEmpty ? "SEM NOME" : viewModel.name.uppercased())
                    .font(.title2).fontWeight(.heavy)
                    .foregroundStyle(.white)
            }

            if !viewModel.isEditing {
                Text(viewModel.objective.uppercased())
                    .font(.caption).fontWeight(.bold)
                    .padding(.horizontal, 16).padding(.vertical, 6)
                    .background(Color.neonGreen.opacity(0.15))
                    .foregroundStyle(Color.neonGreen)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.neonGreen.opacity(0.3), lineWidth: 1))
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gymCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gymBorder, lineWidth: 1))
    }

    private var profileForm: some View {
        VStack(spacing: 0) {
            gymRow("IDADE", value: "\(viewModel.age) anos", isEditing: viewModel.isEditing) {
                if viewModel.isEditing {
                    Picker("", selection: $viewModel.age) {
                        ForEach(1...120, id: \.self) { age in
                            Text("\(age) anos").tag(age)
                                .foregroundStyle(.white)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(Color.neonGreen)
                }
            }

            Divider().background(Color.gymBorder)

            gymRow("ALTURA", value: String(format: "%.1f cm", viewModel.height), isEditing: viewModel.isEditing) {
                if viewModel.isEditing {
                    HStack {
                        TextField("", value: $viewModel.height, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(.white)
                        Text("CM").font(.caption).foregroundStyle(.gray)
                    }
                }
            }

            Divider().background(Color.gymBorder)

            gymRow("PESO", value: String(format: "%.1f kg", viewModel.weight), isEditing: viewModel.isEditing) {
                if viewModel.isEditing {
                    HStack {
                        TextField("", value: $viewModel.weight, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(.white)
                        Text("KG").font(.caption).foregroundStyle(.gray)
                    }
                }
            }

            Divider().background(Color.gymBorder)

            gymRow("OBJETIVO", value: viewModel.objective, isEditing: viewModel.isEditing) {
                if viewModel.isEditing {
                    Picker("", selection: $viewModel.objective) {
                        ForEach(Objective.allCases, id: \.rawValue) { obj in
                            Text(obj.rawValue).tag(obj.rawValue)
                                .foregroundStyle(.white)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(Color.neonGreen)
                }
            }

            Divider().background(Color.gymBorder)

            gymRow("META", value: viewModel.goal.isEmpty ? "ADICIONAR META" : viewModel.goal, isEditing: viewModel.isEditing) {
                if viewModel.isEditing {
                    TextField("EX: GANHAR 5KG MASSA MAGRA", text: $viewModel.goal)
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(.white)
                }
            }
        }
        .padding()
        .background(Color.gymCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gymBorder, lineWidth: 1))
    }

    private func gymRow(_ label: String, value: String, isEditing: Bool, @ViewBuilder editContent: () -> some View) -> some View {
        HStack {
            Text(label).font(.subheadline).fontWeight(.bold)
                .foregroundStyle(.gray).frame(width: 80, alignment: .leading)
            Spacer()
            if isEditing {
                editContent()
            } else {
                Text(value)
                    .font(.subheadline).fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
        }
        .padding(.vertical, 10)
    }

    private var quickLinks: some View {
        VStack(spacing: 12) {
            gymLink("🎯 METAS", icon: "target") { showGoals = true }
            gymLink("🔔 NOTIFICAÇÕES", icon: "bell.fill") { showNotifications = true }
        }
    }

    private func gymLink(_ label: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(label)
                    .font(.subheadline).fontWeight(.bold)
                    .foregroundStyle(.white)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray).font(.caption)
            }
            .padding()
            .background(Color.gymCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gymBorder, lineWidth: 1))
        }
    }
}
