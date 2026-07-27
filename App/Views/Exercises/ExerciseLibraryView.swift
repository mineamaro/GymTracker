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
            VStack(spacing: 0) {
                SearchBar(text: $viewModel.searchQuery, placeholder: "Buscar exercícios...")
                    .padding()

                muscleGroupScroll

                filterBar

                exerciseList
            }
            .background(Color(.systemBackground))
            .navigationTitle("Exercícios")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showCustomExercise = true }) {
                        Image(systemName: "plus")
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
            HStack(spacing: 12) {
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
            filterChip("Favoritos", isActive: viewModel.showFavoritesOnly) {
                viewModel.showFavoritesOnly.toggle()
            }
            filterChip("Personalizados", isActive: viewModel.showCustomOnly) {
                viewModel.showCustomOnly.toggle()
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    private func filterChip(_ label: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.caption)
                .fontWeight(isActive ? .semibold : .regular)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isActive ? Color.accentBlue : Color(.systemGray6))
                .foregroundStyle(isActive ? .white : .primary)
                .clipShape(Capsule())
        }
    }

    private var exerciseList: some View {
        List {
            ForEach(viewModel.filteredExercises, id: \.id) { exercise in
                NavigationLink(destination: ExerciseDetailView(exercise: exercise, dataService: dataService)) {
                    ExerciseRow(exercise: exercise)
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    viewModel.deleteExercise(viewModel.filteredExercises[index])
                }
            }
        }
        .listStyle(.plain)
    }
}
