import Foundation
import SwiftData

@Model
final class UserProfile {
    var name: String
    var age: Int
    var height: Double
    var weight: Double
    var goal: String
    var objective: String
    var experienceLevel: String
    var createdAt: Date
    var updatedAt: Date

    init(name: String = "", age: Int = 25, height: Double = 170, weight: Double = 70,
         goal: String = "", objective: String = Objective.hypertrophy.rawValue,
         experienceLevel: String = "Iniciante") {
        self.name = name
        self.age = age
        self.height = height
        self.weight = weight
        self.goal = goal
        self.objective = objective
        self.experienceLevel = experienceLevel
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
