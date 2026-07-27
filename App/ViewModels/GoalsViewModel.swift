import Foundation
import SwiftData

@Observable
final class GoalsViewModel {
    private var dataService: DataService

    var goals: [Goal] = []
    var showAddGoal = false
    var newGoalTitle: String = ""
    var newGoalDescription: String = ""
    var newGoalTarget: Double = 0
    var newGoalUnit: String = ""
    var newGoalCategory: String = "Geral"
    var newGoalDeadline: Date = Date().addingTimeInterval(86400 * 90)

    init(dataService: DataService) {
        self.dataService = dataService
        loadGoals()
    }

    func loadGoals() {
        goals = dataService.fetchGoals()
    }

    func addGoal() {
        guard !newGoalTitle.isEmpty, newGoalTarget > 0 else { return }
        dataService.addGoal(title: newGoalTitle, description: newGoalDescription,
                           targetValue: newGoalTarget, unit: newGoalUnit,
                           deadline: newGoalDeadline, category: newGoalCategory)
        resetNewGoal()
        loadGoals()
    }

    func updateProgress(_ goal: Goal, newValue: Double) {
        dataService.updateGoalProgress(goal, newValue: newValue)
        loadGoals()
    }

    func deleteGoal(_ goal: Goal) {
        dataService.deleteGoal(goal)
        loadGoals()
    }

    private func resetNewGoal() {
        newGoalTitle = ""
        newGoalDescription = ""
        newGoalTarget = 0
        newGoalUnit = ""
        newGoalCategory = "Geral"
        showAddGoal = false
    }
}
