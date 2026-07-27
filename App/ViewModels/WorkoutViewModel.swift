import Foundation
import SwiftData

@Observable
final class WorkoutViewModel {
    private var dataService: DataService

    var activeSession: WorkoutSession?
    var selectedExercise: Exercise?
    var currentSetNumber: Int = 1
    var currentReps: Int = 10
    var currentWeight: Double = 0
    var currentNotes: String = ""
    var showAddSet = false
    var elapsedTime: TimeInterval = 0
    var isResting = false
    var restTimeRemaining: Int = 0
    var recentSessions: [WorkoutSession] = []
    var exercises: [Exercise] = []

    var hasActiveWorkout: Bool {
        activeSession != nil && activeSession?.endTime == nil
    }

    var groupedSets: [(exerciseId: UUID, exerciseName: String, sets: [WorkoutSet])] {
        guard let session = activeSession else { return [] }
        let grouped = Dictionary(grouping: session.sets.sorted(by: { $0.order < $1.order })) { $0.exerciseId }
        return grouped.map { (key, value) in
            let name = value.first?.exerciseName ?? ""
            return (key, name, value.sorted { $0.setNumber < $1.setNumber })
        }.sorted { $0.sets.first?.order ?? 0 < $1.sets.first?.order ?? 0 }
    }

    init(dataService: DataService) {
        self.dataService = dataService
        loadData()
    }

    func loadData() {
        let sessions = dataService.fetchWorkoutSessions()
        activeSession = sessions.first(where: { $0.endTime == nil })
        recentSessions = Array(dataService.fetchRecentSessions(limit: 10))
        exercises = dataService.fetchExercises()
    }

    func startNewWorkout(name: String = "Treino", templateName: String? = nil) {
        let session = dataService.createWorkoutSession(name: name, templateName: templateName)
        activeSession = session
        loadData()
    }

    func addExerciseToSession(_ exercise: Exercise) {
        selectedExercise = exercise
        currentSetNumber = 1
        if let session = activeSession {
            let existingSets = session.sets.filter { $0.exerciseId == exercise.id }
            currentSetNumber = (existingSets.map { $0.setNumber }.max() ?? 0) + 1
        }
        showAddSet = true
    }

    func saveSet() {
        guard let exercise = selectedExercise, let session = activeSession else { return }
        dataService.addSet(to: session, exerciseId: exercise.id, exerciseName: exercise.name,
                          setNumber: currentSetNumber, reps: currentReps, weight: currentWeight,
                          notes: currentNotes)
        currentSetNumber += 1
        currentReps = 10
        currentWeight = 0
        currentNotes = ""
        showAddSet = false
        loadData()
    }

    func finishWorkout() {
        guard let session = activeSession else { return }
        dataService.finishWorkoutSession(session)
        activeSession = nil
        loadData()
    }

    func deleteSession(_ session: WorkoutSession) {
        dataService.deleteWorkoutSession(session)
        if activeSession?.id == session.id {
            activeSession = nil
        }
        loadData()
    }

    func duplicateSession(_ session: WorkoutSession) {
        _ = dataService.duplicateSession(session)
        loadData()
    }

    func deleteSet(_ set: WorkoutSet) {
        dataService.deleteSet(set)
        loadData()
    }

    func startRest(seconds: Int) {
        isResting = true
        restTimeRemaining = seconds
        NotificationService.shared.scheduleRestTimer(seconds: seconds)
    }

    func cancelRest() {
        isResting = false
        restTimeRemaining = 0
    }

    func activateSession(_ session: WorkoutSession) {
        activeSession = session
    }

    func addSetToExercicio(nome: String) {
        if let exercise = exercises.first(where: { $0.name == nome }) {
            addExerciseToSession(exercise)
        }
    }
}
