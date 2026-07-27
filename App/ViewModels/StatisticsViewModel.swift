import Foundation
import SwiftData

@Observable
final class StatisticsViewModel {
    private var dataService: DataService

    var weeklyVolume: [(Date, Double)] = []
    var monthlyVolume: [(Date, Double)] = []
    var mostTrainedGroups: [(String, Int)] = []
    var mostPerformedExercises: [(String, Int)] = []
    var maxWeights: [(String, Double)] = []
    var totalWorkoutsWeek: Int = 0
    var totalWorkoutsMonth: Int = 0
    var totalWorkoutsYear: Int = 0
    var currentStreak: Int = 0

    init(dataService: DataService) {
        self.dataService = dataService
        loadStatistics()
    }

    func loadStatistics() {
        weeklyVolume = dataService.weeklyVolume()
        monthlyVolume = dataService.monthlyVolume()
        mostTrainedGroups = dataService.mostTrainedMuscleGroups()
        mostPerformedExercises = dataService.mostPerformedExercises()
        maxWeights = dataService.maxWeightPerExercise()
        totalWorkoutsWeek = dataService.totalWorkoutsThisWeek()
        totalWorkoutsMonth = dataService.totalWorkoutsThisMonth()
        currentStreak = dataService.currentStreak()

        let startOfYear = Date().startOfYear
        totalWorkoutsYear = dataService.fetchSessions(from: startOfYear, to: Date()).count
    }
}
