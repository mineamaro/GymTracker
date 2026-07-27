import SwiftUI

struct ExerciseLibraryView: View {
    @State private var viewModel: ExerciseLibraryViewModel
    @State private var showCustomExercise = false
    private let dataService: DataService

    init(dataService: DataService) {
        self.dataService = dataService
        _viewModel = State(initialValue: ExerciseLibraryViewModel(dataService: dataService))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.gymBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    SearchBar(text: $viewModel.searchQuery, placeholder: "BUSCAR EXERCÍCIOS...")
                        .padding()

                    muscleGroupScroll
                    filterBar
                    exerciseList
                }
            }
            .navigationTitle("🏋️ EXERCÍCIOS")
            .toolbarBackground(Color.gymCard, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showCustomExercise = true }) {
                        Image(systemName: "plus")
                            .foregroundStyle(Color.neonGreen)
                    }
                }
            }
            .sheet(isPresented: $showCustomExercise) {
                CustomExerciseView { name, group, desc, equip, muscles in
                    viewModel.createCustomExercise(name: name, muscleGroup: group, description: desc, equipment: equip, musclesWorked: muscles)
                }
            }
        }
    }

    private var muscleGroupScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(MuscleGroup.allCases, id: \.rawValue) { group in
                    MuscleGroupIcon(
                        muscleGroup: group.rawValue,
                        isSelected: viewModel.selectedMuscleGroup == group.rawValue
                    )
                    .onTapGesture {
                        viewModel.selectedMuscleGroup = viewModel.selectedMuscleGroup == group.rawValue ? nil : group.rawValue
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    private var filterBar: some View {
        HStack(spacing: 8) {
            gymFilterChip("⭐ FAVORITOS", isActive: viewModel.showFavoritesOnly) {
                viewModel.showFavoritesOnly.toggle()
            }
            gymFilterChip("🔧 PERSONALIZADOS", isActive: viewModel.showCustomOnly) {
                viewModel.showCustomOnly.toggle()
            }
            Spacer()
            Text("\(viewModel.filteredExercises.count)")
                .font(.caption).fontWeight(.bold)
                .foregroundStyle(.gray)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    private func gymFilterChip(_ label: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.caption).fontWeight(.bold)
                .padding(.horizontal, 14).padding(.vertical, 7)
                .background(isActive ? Color.neonBlue.opacity(0.2) : Color.gymCard)
                .foregroundStyle(isActive ? Color.neonBlue : .gray)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(isActive ? Color.neonBlue.opacity(0.3) : Color.gymBorder, lineWidth: 1))
        }
    }

    private var exerciseList: some View {
        List {
            ForEach(viewModel.filteredExercises, id: \.id) { exercise in
                NavigationLink(destination: ExerciseDetailView(exercise: exercise, dataService: dataService)) {
                    ExerciseRow(exercise: exercise)
                }
                .listRowBackground(Color.gymCard)
                .listRowSeparator(.hidden)
            }
            .onDelete { indexSet in
                for index in indexSet {
                    viewModel.deleteExercise(viewModel.filteredExercises[index])
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}
