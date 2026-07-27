import SwiftUI

struct ExerciseLibraryView: View {
    @State private var viewModel: ExerciseLibraryViewModel
    @State private var showCustomExercise = false
    @State private var searchText = ""
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
                    // Search
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(Color.neonGreen)
                            .font(.subheadline)
                        TextField("BUSCAR EXERCÍCIOS...", text: $searchText)
                            .font(.subheadline).fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .onChange(of: searchText) { _, new in viewModel.searchQuery = new }
                        if !searchText.isEmpty {
                            Button(action: { searchText = ""; viewModel.searchQuery = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                    .padding(14)
                    .background(Color.gymCard)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.gymBorder, lineWidth: 1))
                    .padding()

                    // Muscle Groups
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(MuscleGroup.allCases, id: \.rawValue) { group in
                                MuscleGroupIcon(
                                    muscleGroup: group.rawValue,
                                    isSelected: viewModel.selectedMuscleGroup == group.rawValue
                                )
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3)) {
                                        viewModel.selectedMuscleGroup = viewModel.selectedMuscleGroup == group.rawValue ? nil : group.rawValue
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Filters
                    HStack(spacing: 8) {
                        gymChip("⭐ FAVORITOS", isActive: viewModel.showFavoritesOnly) {
                            withAnimation { viewModel.showFavoritesOnly.toggle() }
                        }
                        gymChip("🔧 PERSONALIZADOS", isActive: viewModel.showCustomOnly) {
                            withAnimation { viewModel.showCustomOnly.toggle() }
                        }
                        Spacer()
                        Text("\(viewModel.filteredExercises.count)")
                            .font(.caption).fontWeight(.bold).foregroundStyle(.gray)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)

                    // Exercise List - LazyVStack for performance
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.filteredExercises, id: \.id) { exercise in
                                NavigationLink(destination: ExerciseDetailView(exercise: exercise, dataService: dataService)) {
                                    ExerciseRow(exercise: exercise)
                                        .padding(.horizontal)
                                        .padding(.vertical, 6)
                                }
                                .buttonStyle(.plain)

                                Divider()
                                    .background(Color.gymBorder.opacity(0.4))
                                    .padding(.leading, 70)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("🏋️ EXERCÍCIOS")
            .toolbarBackground(Color.gymCard, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showCustomExercise = true }) {
                        Image(systemName: "plus")
                            .foregroundStyle(Color.neonGreen)
                            .neonGlow(color: .neonGreen, radius: 4)
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

    private func gymChip(_ label: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.caption).fontWeight(.bold)
                .padding(.horizontal, 14).padding(.vertical, 7)
                .background(isActive ? Color.neonBlue.opacity(0.2) : Color.gymCard)
                .foregroundStyle(isActive ? Color.neonBlue : .gray)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(isActive ? Color.neonBlue.opacity(0.4) : Color.gymBorder, lineWidth: 1))
        }
    }
}
