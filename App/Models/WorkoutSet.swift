import Foundation
import SwiftData

@Model
final class WorkoutSet {
    @Attribute(.unique) var id: UUID
    var exerciseId: UUID
    var exerciseName: String
    var setNumber: Int
    var reps: Int
    var weight: Double
    var setType: String
    var notes: String
    var isPersonalRecord: Bool
    var order: Int

    var volume: Double {
        weight * Double(reps)
    }

    var oneRMEstimate: Double {
        guard reps > 0 else { return 0 }
        return weight * (1 + Double(reps) / 30.0)
    }

    init(id: UUID = UUID(), exerciseId: UUID, exerciseName: String, setNumber: Int,
         reps: Int = 0, weight: Double = 0, setType: String = "Normal",
         notes: String = "", isPersonalRecord: Bool = false, order: Int = 0) {
        self.id = id
        self.exerciseId = exerciseId
        self.exerciseName = exerciseName
        self.setNumber = setNumber
        self.reps = reps
        self.weight = weight
        self.setType = setType
        self.notes = notes
        self.isPersonalRecord = isPersonalRecord
        self.order = order
    }
}
