import Foundation
import SwiftData

@Observable
final class DiaryViewModel {
    private var dataService: DataService

    var entries: [DiaryEntry] = []
    var selectedDate: Date = Date()
    var currentEntry: DiaryEntry?

    var mealDescription: String = ""
    var dietNotes: String = ""
    var mood: String = "Normal"
    var energyLevel: String = "Média"
    var observations: String = ""
    var sleepHours: Double = 8

    init(dataService: DataService) {
        self.dataService = dataService
        loadEntries()
    }

    func loadEntries() {
        entries = dataService.fetchDiaryEntries()
        loadEntryForSelectedDate()
    }

    func loadEntryForSelectedDate() {
        currentEntry = dataService.fetchDiaryEntry(for: selectedDate)
        if let entry = currentEntry {
            mealDescription = entry.mealDescription
            dietNotes = entry.dietNotes
            mood = entry.mood
            energyLevel = entry.energyLevel
            observations = entry.observations
            sleepHours = entry.sleepHours
        } else {
            mealDescription = ""
            dietNotes = ""
            mood = "Normal"
            energyLevel = "Média"
            observations = ""
            sleepHours = 8
        }
    }

    func selectDate(_ date: Date) {
        selectedDate = date
        loadEntryForSelectedDate()
    }

    func saveEntry() {
        if let existing = currentEntry {
            existing.mealDescription = mealDescription
            existing.dietNotes = dietNotes
            existing.mood = mood
            existing.energyLevel = energyLevel
            existing.observations = observations
            existing.sleepHours = sleepHours
            dataService.saveDiaryEntry(existing)
        } else {
            dataService.addDiaryEntry(meal: mealDescription, diet: dietNotes, mood: mood,
                                      energy: energyLevel, observations: observations, sleep: sleepHours)
        }
        loadEntries()
    }

    func deleteEntry(_ entry: DiaryEntry) {
        dataService.deleteDiaryEntry(entry)
        if currentEntry?.id == entry.id {
            currentEntry = nil
        }
        loadEntries()
    }
}
