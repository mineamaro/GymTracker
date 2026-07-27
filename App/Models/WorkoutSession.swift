import Foundation
import SwiftData

@Model
final class WorkoutSession {
    @Attribute(.unique) var id: UUID
    var name: String
    var date: Date
    var startTime: Date
    var endTime: Date?
    var notes: String
    var templateName: String?

    @Relationship(deleteRule: .cascade) var sets: [WorkoutSet]

    var duration: TimeInterval {
        guard let end = endTime else { return 0 }
        return end.timeIntervalSince(startTime)
    }

    var totalVolume: Double {
        sets.reduce(0) { $0 + $1.volume }
    }

    var totalSets: Int {
        sets.count
    }

    var completedExercises: Int {
        Set(sets.map { $0.exerciseId }).count
    }

    init(id: UUID = UUID(), name: String = "", date: Date = Date(), startTime: Date = Date(),
         endTime: Date? = nil, notes: String = "", templateName: String? = nil) {
        self.id = id
        self.name = name
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.notes = notes
        self.templateName = templateName
        self.sets = []
    }
}
