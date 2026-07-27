import Foundation
import SwiftData

final class DataService {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - User Profile

    func fetchUserProfile() -> UserProfile? {
        let descriptor = FetchDescriptor<UserProfile>()
        return try? modelContext.fetch(descriptor).first
    }

    func saveUserProfile(_ profile: UserProfile) {
        profile.updatedAt = Date()
        try? modelContext.save()
    }

    func createOrUpdateProfile(name: String, age: Int, height: Double, weight: Double, goal: String, objective: String) {
        if let existing = fetchUserProfile() {
            existing.name = name
            existing.age = age
            existing.height = height
            existing.weight = weight
            existing.goal = goal
            existing.objective = objective
            existing.updatedAt = Date()
        } else {
            let profile = UserProfile(name: name, age: age, height: height, weight: weight, goal: goal, objective: objective)
            modelContext.insert(profile)
        }
        try? modelContext.save()
    }

    // MARK: - Exercises

    func fetchExercises() -> [Exercise] {
        let descriptor = FetchDescriptor<Exercise>(sortBy: [SortDescriptor(\.name)])
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    func fetchExercises(for muscleGroup: String) -> [Exercise] {
        let predicate = #Predicate<Exercise> { $0.muscleGroup == muscleGroup }
        let descriptor = FetchDescriptor<Exercise>(predicate: predicate, sortBy: [SortDescriptor(\.name)])
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    func fetchFavoriteExercises() -> [Exercise] {
        let predicate = #Predicate<Exercise> { $0.isFavorite }
        let descriptor = FetchDescriptor<Exercise>(predicate: predicate, sortBy: [SortDescriptor(\.name)])
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    func searchExercises(query: String) -> [Exercise] {
        let exercises = fetchExercises()
        guard !query.isEmpty else { return exercises }
        return exercises.filter { $0.name.localizedCaseInsensitiveContains(query) || $0.muscleGroup.localizedCaseInsensitiveContains(query) }
    }

    func saveExercise(_ exercise: Exercise) {
        try? modelContext.save()
    }

    func toggleFavorite(_ exercise: Exercise) {
        exercise.isFavorite.toggle()
        try? modelContext.save()
    }

    func deleteExercise(_ exercise: Exercise) {
        modelContext.delete(exercise)
        try? modelContext.save()
    }

    func createExercise(name: String, muscleGroup: String, description: String, equipment: String, musclesWorked: String) {
        let exercise = Exercise(name: name, muscleGroup: muscleGroup, exerciseDescription: description, equipment: equipment, musclesWorked: musclesWorked, isCustom: true)
        modelContext.insert(exercise)
        try? modelContext.save()
    }

    // MARK: - Workout Sessions

    func fetchWorkoutSessions() -> [WorkoutSession] {
        let descriptor = FetchDescriptor<WorkoutSession>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    func fetchRecentSessions(limit: Int = 5) -> [WorkoutSession] {
        var descriptor = FetchDescriptor<WorkoutSession>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        descriptor.fetchLimit = limit
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    func fetchSessions(from startDate: Date, to endDate: Date) -> [WorkoutSession] {
        let predicate = #Predicate<WorkoutSession> { $0.date >= startDate && $0.date <= endDate }
        let descriptor = FetchDescriptor<WorkoutSession>(predicate: predicate, sortBy: [SortDescriptor(\.date)])
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    func fetchSessions(for exerciseId: UUID) -> [WorkoutSession] {
        let allSessions = fetchWorkoutSessions()
        return allSessions.filter { session in
            session.sets.contains { $0.exerciseId == exerciseId }
        }
    }

    func createWorkoutSession(name: String, templateName: String? = nil) -> WorkoutSession {
        let session = WorkoutSession(name: name, startTime: Date(), templateName: templateName)
        modelContext.insert(session)
        try? modelContext.save()
        return session
    }

    func finishWorkoutSession(_ session: WorkoutSession) {
        session.endTime = Date()
        try? modelContext.save()
    }

    func deleteWorkoutSession(_ session: WorkoutSession) {
        modelContext.delete(session)
        try? modelContext.save()
    }

    func duplicateSession(_ session: WorkoutSession) -> WorkoutSession {
        let newSession = WorkoutSession(
            name: session.name + " (cópia)",
            date: Date(),
            startTime: Date(),
            templateName: session.templateName ?? session.name
        )
        modelContext.insert(newSession)
        for set in session.sets {
            let newSet = WorkoutSet(
                exerciseId: set.exerciseId,
                exerciseName: set.exerciseName,
                setNumber: set.setNumber,
                reps: set.reps,
                weight: set.weight,
                setType: set.setType,
                notes: set.notes,
                order: set.order
            )
            newSession.sets.append(newSet)
        }
        try? modelContext.save()
        return newSession
    }

    // MARK: - Sets

    func addSet(to session: WorkoutSession, exerciseId: UUID, exerciseName: String,
                setNumber: Int, reps: Int, weight: Double, notes: String = "") {
        let set = WorkoutSet(exerciseId: exerciseId, exerciseName: exerciseName,
                             setNumber: setNumber, reps: reps, weight: weight,
                             notes: notes, order: session.sets.count)
        session.sets.append(set)
        checkPersonalRecord(set)
        try? modelContext.save()
    }

    func updateSet(_ set: WorkoutSet, reps: Int, weight: Double, notes: String) {
        set.reps = reps
        set.weight = weight
        set.notes = notes
        checkPersonalRecord(set)
        try? modelContext.save()
    }

    func deleteSet(_ set: WorkoutSet) {
        modelContext.delete(set)
        try? modelContext.save()
    }

    private func checkPersonalRecord(_ set: WorkoutSet) {
        let allSets = fetchAllSets(for: set.exerciseId)
        let maxWeight = allSets.map { $0.weight }.max() ?? 0
        set.isPersonalRecord = set.weight >= maxWeight && set.weight > 0
    }

    private func fetchAllSets(for exerciseId: UUID) -> [WorkoutSet] {
        let allSessions = fetchWorkoutSessions()
        return allSessions.flatMap { $0.sets.filter { $0.exerciseId == exerciseId } }
    }

    func fetchPersonalRecords(for exerciseId: UUID) -> [WorkoutSet] {
        let allSets = fetchAllSets(for: exerciseId)
        return allSets.filter { $0.isPersonalRecord }
    }

    // MARK: - Progress Photos

    func fetchProgressPhotos() -> [ProgressPhoto] {
        let descriptor = FetchDescriptor<ProgressPhoto>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    func addProgressPhoto(photo: ProgressPhoto) {
        modelContext.insert(photo)
        try? modelContext.save()
    }

    func deleteProgressPhoto(_ photo: ProgressPhoto) {
        modelContext.delete(photo)
        try? modelContext.save()
    }

    // MARK: - Diary Entries

    func fetchDiaryEntries() -> [DiaryEntry] {
        let descriptor = FetchDescriptor<DiaryEntry>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    func fetchDiaryEntry(for date: Date) -> DiaryEntry? {
        let start = date.startOfDay
        let end = date.endOfDay
        let predicate = #Predicate<DiaryEntry> { $0.date >= start && $0.date <= end }
        let descriptor = FetchDescriptor<DiaryEntry>(predicate: predicate)
        return try? modelContext.fetch(descriptor).first
    }

    func saveDiaryEntry(_ entry: DiaryEntry) {
        try? modelContext.save()
    }

    func addDiaryEntry(meal: String, diet: String, mood: String, energy: String, observations: String, sleep: Double) {
        let entry = DiaryEntry(mealDescription: meal, dietNotes: diet, mood: mood,
                               energyLevel: energy, observations: observations, sleepHours: sleep)
        modelContext.insert(entry)
        try? modelContext.save()
    }

    func deleteDiaryEntry(_ entry: DiaryEntry) {
        modelContext.delete(entry)
        try? modelContext.save()
    }

    // MARK: - Goals

    func fetchGoals() -> [Goal] {
        let descriptor = FetchDescriptor<Goal>(sortBy: [SortDescriptor(\.startDate, order: .reverse)])
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    func fetchActiveGoals() -> [Goal] {
        let predicate = #Predicate<Goal> { !$0.isCompleted }
        let descriptor = FetchDescriptor<Goal>(predicate: predicate, sortBy: [SortDescriptor(\.startDate)])
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    func saveGoal(_ goal: Goal) {
        try? modelContext.save()
    }

    func addGoal(title: String, description: String, targetValue: Double, unit: String, deadline: Date?, category: String) {
        let goal = Goal(title: title, goalDescription: description, targetValue: targetValue, unit: unit,
                        deadline: deadline, category: category)
        modelContext.insert(goal)
        try? modelContext.save()
    }

    func updateGoalProgress(_ goal: Goal, newValue: Double) {
        goal.currentValue = newValue
        if goal.currentValue >= goal.targetValue {
            goal.isCompleted = true
        }
        try? modelContext.save()
    }

    func deleteGoal(_ goal: Goal) {
        modelContext.delete(goal)
        try? modelContext.save()
    }

    // MARK: - Statistics

    func totalWorkoutsThisWeek() -> Int {
        let start = Date().startOfWeek
        return fetchSessions(from: start, to: Date()).count
    }

    func totalWorkoutsThisMonth() -> Int {
        let start = Date().startOfMonth
        return fetchSessions(from: start, to: Date()).count
    }

    func currentStreak() -> Int {
        let sessions = fetchWorkoutSessions()
        guard !sessions.isEmpty else { return 0 }
        let calendar = Calendar.current
        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())
        let sessionDates = Set(sessions.map { calendar.startOfDay(for: $0.date) })
        while sessionDates.contains(currentDate) {
            streak += 1
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
        }
        return streak
    }

    func weeklyVolume() -> [(Date, Double)] {
        let start = Date().startOfWeek
        let sessions = fetchSessions(from: start, to: Date())
        let calendar = Calendar.current
        var volumeByDay: [Date: Double] = [:]
        for session in sessions {
            let day = calendar.startOfDay(for: session.date)
            volumeByDay[day, default: 0] += session.totalVolume
        }
        return volumeByDay.sorted { $0.key < $1.key }
    }

    func monthlyVolume() -> [(Date, Double)] {
        let start = Date().startOfYear
        let sessions = fetchSessions(from: start, to: Date())
        let calendar = Calendar.current
        var volumeByMonth: [Date: Double] = [:]
        for session in sessions {
            let month = calendar.date(from: calendar.dateComponents([.year, .month], from: session.date))!
            volumeByMonth[month, default: 0] += session.totalVolume
        }
        return volumeByMonth.sorted { $0.key < $1.key }
    }

    func mostTrainedMuscleGroups() -> [(String, Int)] {
        let sessions = fetchWorkoutSessions()
        var groupCount: [String: Int] = [:]
        for session in sessions {
            let exerciseIds = Set(session.sets.map { $0.exerciseId })
            let exercises = fetchExercises()
            for exId in exerciseIds {
                if let exercise = exercises.first(where: { $0.id == exId }) {
                    groupCount[exercise.muscleGroup, default: 0] += 1
                }
            }
        }
        return groupCount.sorted { $0.value > $1.value }
    }

    func maxWeightPerExercise() -> [(String, Double)] {
        let sessions = fetchWorkoutSessions()
        var maxWeight: [UUID: Double] = [:]
        for session in sessions {
            for set in session.sets {
                let current = maxWeight[set.exerciseId] ?? 0
                if set.weight > current {
                    maxWeight[set.exerciseId] = set.weight
                }
            }
        }
        let exercises = fetchExercises()
        return maxWeight.compactMap { (id, weight) in
            guard let exercise = exercises.first(where: { $0.id == id }) else { return nil }
            return (exercise.name, weight)
        }.sorted { $0.1 > $1.1 }
    }

    func mostPerformedExercises() -> [(String, Int)] {
        let sessions = fetchWorkoutSessions()
        var exerciseCount: [UUID: Int] = [:]
        for session in sessions {
            let uniqueExercises = Set(session.sets.map { $0.exerciseId })
            for exId in uniqueExercises {
                exerciseCount[exId, default: 0] += 1
            }
        }
        let exercises = fetchExercises()
        return exerciseCount.compactMap { (id, count) in
            guard let exercise = exercises.first(where: { $0.id == id }) else { return nil }
            return (exercise.name, count)
        }.sorted { $0.1 > $1.1 }
    }

    func volumeHistory(for exerciseId: UUID) -> [(Date, Double)] {
        let sessions = fetchWorkoutSessions().filter { session in
            session.sets.contains { $0.exerciseId == exerciseId }
        }
        return sessions.map { ($0.date, $0.sets.filter { $0.exerciseId == exerciseId }.reduce(0) { $0 + $1.volume }) }
            .sorted { $0.0 < $1.0 }
    }

    func loadHistory(for exerciseId: UUID) -> [(Date, Int, String)] {
        let sessions = fetchSessions(for: exerciseId)
        var history: [(Date, Int, String)] = []
        for session in sessions {
            let exerciseSets = session.sets.filter { $0.exerciseId == exerciseId }.sorted { $0.setNumber < $1.setNumber }
            if !exerciseSets.isEmpty {
                let details = exerciseSets.map { "\($0.setNumber)ª série: \($0.reps) reps × \(String(format: "%.1f", $0.weight)) kg" }.joined(separator: "\n")
                history.append((session.date, exerciseSets.count, details))
            }
        }
        return history.sorted { $0.0 > $1.0 }
    }

    func allSetsForExercise(_ exerciseId: UUID) -> [(Date, Int, Double, Double)] {
        let sessions = fetchWorkoutSessions().filter { session in
            session.sets.contains { $0.exerciseId == exerciseId }
        }
        return sessions.flatMap { session in
            session.sets.filter { $0.exerciseId == exerciseId }.map { (session.date, $0.reps, $0.weight, $0.volume) }
        }.sorted { $0.0 < $1.0 }
    }

    // MARK: - Notification Preferences

    func fetchNotificationPreferences() -> NotificationPreference {
        let descriptor = FetchDescriptor<NotificationPreference>()
        if let existing = try? modelContext.fetch(descriptor).first {
            return existing
        }
        let prefs = NotificationPreference()
        modelContext.insert(prefs)
        try? modelContext.save()
        return prefs
    }

    func saveNotificationPreferences(_ prefs: NotificationPreference) {
        try? modelContext.save()
    }
}
