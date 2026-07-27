import Foundation
import SwiftData

@Observable
final class HistoryViewModel {
    private var dataService: DataService

    var sessions: [WorkoutSession] = []
    var selectedExercise: Exercise?
    var exerciseHistory: [(date: Date, sets: Int, details: String)] = []
    var volumeChartData: [(Date, Double)] = []
    var weightChartData: [(Date, Double)] = []

    init(dataService: DataService) {
        self.dataService = dataService
        loadSessions()
    }

    func loadSessions() {
        sessions = dataService.fetchWorkoutSessions()
    }

    func loadExerciseHistory(_ exercise: Exercise) {
        selectedExercise = exercise
        let rawHistory = dataService.loadHistory(for: exercise.id)
        exerciseHistory = rawHistory.map { (date: $0.0, sets: $0.1, details: $0.2) }
        volumeChartData = dataService.volumeHistory(for: exercise.id)

        let allSets = dataService.allSetsForExercise(exercise.id)
        let groupedByDate = Dictionary(grouping: allSets) { Calendar.current.startOfDay(for: $0.0) }
        weightChartData = groupedByDate.map { (date, sets) in
            (date, sets.map { $0.2 }.max() ?? 0)
        }.sorted { $0.0 < $1.0 }
    }

    func deleteSession(_ session: WorkoutSession) {
        dataService.deleteWorkoutSession(session)
        loadSessions()
    }

    func duplicateSession(_ session: WorkoutSession) {
        _ = dataService.duplicateSession(session)
        loadSessions()
    }
}
