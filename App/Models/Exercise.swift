import Foundation
import SwiftData

@Model
final class Exercise {
    @Attribute(.unique) var id: UUID
    var name: String
    var muscleGroup: String
    var exerciseDescription: String
    var equipment: String
    var musclesWorked: String
    var imageName: String
    var isCustom: Bool
    var isFavorite: Bool
    var createdAt: Date

    init(id: UUID = UUID(), name: String, muscleGroup: String, exerciseDescription: String = "",
         equipment: String = "", musclesWorked: String = "", imageName: String = "figure.strengthtraining.traditional",
         isCustom: Bool = false, isFavorite: Bool = false) {
        self.id = id
        self.name = name
        self.muscleGroup = muscleGroup
        self.exerciseDescription = exerciseDescription
        self.equipment = equipment
        self.musclesWorked = musclesWorked
        self.imageName = imageName
        self.isCustom = isCustom
        self.isFavorite = isFavorite
        self.createdAt = Date()
    }
}
