import Foundation
import UserNotifications

final class NotificationService {
    static let shared = NotificationService()

    private init() {}

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
    }

    func scheduleWorkoutReminder(at time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Hora de Treinar! 🏋️"
        content.body = "Não esqueça do treino de hoje. Vamos com tudo!"
        content.sound = .default

        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "workout_reminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    func scheduleWeightReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Registre seu Peso"
        content.body = "Não se esqueça de registrar seu peso hoje!"
        content.sound = .default

        var components = DateComponents()
        components.hour = 20
        components.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "weight_reminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    func schedulePhotoReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Tire sua Foto"
        content.body = "Hora de registrar sua evolução com uma foto!"
        content.sound = .default

        var components = DateComponents()
        components.weekday = 1
        components.hour = 12
        components.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "photo_reminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    func scheduleWaterReminder(intervalMinutes: Int) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["water_reminder"])

        let content = UNMutableNotificationContent()
        content.title = "Beba Água 💧"
        content.body = "Hora de se hidratar! Mantenha-se hidratado durante o treino."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(intervalMinutes * 60), repeats: true)
        let request = UNNotificationRequest(identifier: "water_reminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    func removeWorkoutReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["workout_reminder"])
    }

    func removeWeightReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["weight_reminder"])
    }

    func removePhotoReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["photo_reminder"])
    }

    func removeWaterReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["water_reminder"])
    }

    func scheduleRestTimer(seconds: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Descanso Finalizado! ⏱️"
        content.body = "Hora de partir para a próxima série!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(seconds), repeats: false)
        let request = UNNotificationRequest(identifier: "rest_timer_\(Date().timeIntervalSince1970)", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
}
