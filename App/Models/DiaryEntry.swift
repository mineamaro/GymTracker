import Foundation
import SwiftData

@Model
final class DiaryEntry {
    @Attribute(.unique) var id: UUID
    var date: Date
    var mealDescription: String
    var dietNotes: String
    var mood: String
    var energyLevel: String
    var observations: String
    var sleepHours: Double

    init(id: UUID = UUID(), date: Date = Date(), mealDescription: String = "",
         dietNotes: String = "", mood: String = "Normal", energyLevel: String = "Média",
         observations: String = "", sleepHours: Double = 0) {
        self.id = id
        self.date = date
        self.mealDescription = mealDescription
        self.dietNotes = dietNotes
        self.mood = mood
        self.energyLevel = energyLevel
        self.observations = observations
        self.sleepHours = sleepHours
    }
}
