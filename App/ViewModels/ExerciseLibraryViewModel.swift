import Foundation
import SwiftData

@Observable
final class ExerciseLibraryViewModel {
    private var dataService: DataService

    var exercises: [Exercise] = []
    var selectedMuscleGroup: String? = nil
    var searchQuery: String = ""
    var showFavoritesOnly: Bool = false
    var showCustomOnly: Bool = false

    var filteredExercises: [Exercise] {
        var result = exercises
        if let group = selectedMuscleGroup {
            result = result.filter { $0.muscleGroup == group }
        }
        if showFavoritesOnly {
            result = result.filter { $0.isFavorite }
        }
        if showCustomOnly {
            result = result.filter { $0.isCustom }
        }
        if !searchQuery.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) }
        }
        return result
    }

    var muscleGroups: [String] {
        Array(Set(exercises.map { $0.muscleGroup })).sorted()
    }

    init(dataService: DataService) {
        self.dataService = dataService
        loadExercises()
    }

    func loadExercises() {
        exercises = dataService.fetchExercises()
    }

    func toggleFavorite(_ exercise: Exercise) {
        dataService.toggleFavorite(exercise)
        loadExercises()
    }

    func createCustomExercise(name: String, muscleGroup: String, description: String, equipment: String, musclesWorked: String) {
        dataService.createExercise(name: name, muscleGroup: muscleGroup, description: description, equipment: equipment, musclesWorked: musclesWorked)
        loadExercises()
    }

    func deleteExercise(_ exercise: Exercise) {
        dataService.deleteExercise(exercise)
        loadExercises()
    }
}
