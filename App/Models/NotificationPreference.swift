import Foundation
import SwiftData

@Model
final class NotificationPreference {
    @Attribute(.unique) var id: UUID
    var workoutReminderEnabled: Bool
    var workoutReminderTime: Date
    var weightReminderEnabled: Bool
    var photoReminderEnabled: Bool
    var waterReminderEnabled: Bool
    var waterReminderInterval: Int
    var restTimerDuration: Int

    init(id: UUID = UUID(), workoutReminderEnabled: Bool = true,
         workoutReminderTime: Date = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date()) ?? Date(),
         weightReminderEnabled: Bool = false, photoReminderEnabled: Bool = false,
         waterReminderEnabled: Bool = false, waterReminderInterval: Int = 60,
         restTimerDuration: Int = 90) {
        self.id = id
        self.workoutReminderEnabled = workoutReminderEnabled
        self.workoutReminderTime = workoutReminderTime
        self.weightReminderEnabled = weightReminderEnabled
        self.photoReminderEnabled = photoReminderEnabled
        self.waterReminderEnabled = waterReminderEnabled
        self.waterReminderInterval = waterReminderInterval
        self.restTimerDuration = restTimerDuration
    }
}
