import Foundation
import SwiftData

@Model
final class ProgressPhoto {
    @Attribute(.unique) var id: UUID
    var date: Date
    var frontPhotoData: Data?
    var backPhotoData: Data?
    var sidePhotoData: Data?
    var bodyWeight: Double
    var bodyFat: Double?
    var notes: String

    init(id: UUID = UUID(), date: Date = Date(), frontPhotoData: Data? = nil,
         backPhotoData: Data? = nil, sidePhotoData: Data? = nil,
         bodyWeight: Double = 0, bodyFat: Double? = nil, notes: String = "") {
        self.id = id
        self.date = date
        self.frontPhotoData = frontPhotoData
        self.backPhotoData = backPhotoData
        self.sidePhotoData = sidePhotoData
        self.bodyWeight = bodyWeight
        self.bodyFat = bodyFat
        self.notes = notes
    }
}
