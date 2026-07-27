import SwiftUI
import SwiftData

@main
struct GymTrackerApp: App {
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(
                for: UserProfile.self, Exercise.self, WorkoutSession.self,
                WorkoutSet.self, ProgressPhoto.self, DiaryEntry.self,
                Goal.self, NotificationPreference.self
            )
        } catch {
            fatalError("Falha ao inicializar ModelContainer: \(error.localizedDescription)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
        }
    }
}
