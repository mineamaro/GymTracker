import Foundation
import SwiftData

@Observable
final class DashboardViewModel {
    private var dataService: DataService

    var todayWorkout: WorkoutSession?
    var recentSessions: [WorkoutSession] = []
    var currentStreak: Int = 0
    var todayVolume: Double = 0
    var todaySets: Int = 0
    var todayExercises: Int = 0
    var workoutDuration: TimeInterval = 0
    var activeGoal: Goal?
    var userName: String = ""

    init(dataService: DataService) {
        self.dataService = dataService
        loadData()
    }

    func loadData() {
        let calendar = Calendar.current
        let today = Date()
        let startOfDay = calendar.startOfDay(for: today)

        let sessions = dataService.fetchWorkoutSessions()
        todayWorkout = sessions.first(where: { calendar.isDate($0.date, inSameDayAs: today) })
        recentSessions = Array(dataService.fetchRecentSessions(limit: 5))
        currentStreak = dataService.currentStreak()

        if let session = todayWorkout {
            todayVolume = session.totalVolume
            todaySets = session.totalSets
            todayExercises = session.completedExercises
            if let end = session.endTime {
                workoutDuration = end.timeIntervalSince(session.startTime)
            } else {
                workoutDuration = Date().timeIntervalSince(session.startTime)
            }
        }

        let profile = dataService.fetchUserProfile()
        userName = profile?.name ?? ""

        activeGoal = dataService.fetchActiveGoals().first
    }

    func startWorkout(name: String = "Treino") {
        _ = dataService.createWorkoutSession(name: name)
        loadData()
    }

    func finishTodayWorkout() {
        guard let session = todayWorkout else { return }
        dataService.finishWorkoutSession(session)
        loadData()
    }

    func refresh() {
        loadData()
    }
}
