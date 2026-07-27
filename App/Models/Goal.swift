import Foundation
import SwiftData

@Model
final class Goal {
    @Attribute(.unique) var id: UUID
    var title: String
    var goalDescription: String
    var targetValue: Double
    var currentValue: Double
    var unit: String
    var startDate: Date
    var deadline: Date?
    var isCompleted: Bool
    var category: String
    var iconName: String

    var progress: Double {
        guard targetValue > 0 else { return 0 }
        return min(currentValue / targetValue, 1.0)
    }

    var remainingValue: Double {
        max(targetValue - currentValue, 0)
    }

    init(id: UUID = UUID(), title: String, goalDescription: String = "",
         targetValue: Double, currentValue: Double = 0, unit: String = "",
         startDate: Date = Date(), deadline: Date? = nil,
         isCompleted: Bool = false, category: String = "Geral", iconName: String = "star.fill") {
        self.id = id
        self.title = title
        self.goalDescription = goalDescription
        self.targetValue = targetValue
        self.currentValue = currentValue
        self.unit = unit
        self.startDate = startDate
        self.deadline = deadline
        self.isCompleted = isCompleted
        self.category = category
        self.iconName = iconName
    }
}
