import Foundation
import SwiftData

@Observable
final class ProfileViewModel {
    private var dataService: DataService

    var name: String = ""
    var age: Int = 25
    var height: Double = 170
    var weight: Double = 70
    var goal: String = ""
    var objective: String = Objective.hypertrophy.rawValue
    var experienceLevel: String = "Iniciante"
    var isEditing = false

    init(dataService: DataService) {
        self.dataService = dataService
        loadProfile()
    }

    func loadProfile() {
        if let profile = dataService.fetchUserProfile() {
            name = profile.name
            age = profile.age
            height = profile.height
            weight = profile.weight
            goal = profile.goal
            objective = profile.objective
            experienceLevel = profile.experienceLevel
        }
    }

    func saveProfile() {
        dataService.createOrUpdateProfile(name: name, age: age, height: height, weight: weight, goal: goal, objective: objective)
        isEditing = false
        loadProfile()
    }
}
