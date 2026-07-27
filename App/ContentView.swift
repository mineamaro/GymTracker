import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var dataService: DataService?
    @State private var selectedTab = 0

    var body: some View {
        Group {
            if let dataService = dataService {
                TabView(selection: $selectedTab) {
                    DashboardView(dataService: dataService)
                        .tabItem {
                            Label("Início", systemImage: selectedTab == 0 ? "house.fill" : "house")
                        }
                        .tag(0)

                    WorkoutListView(dataService: dataService)
                        .tabItem {
                            Label("Treinos", systemImage: selectedTab == 1 ? "figure.strengthtraining.traditional.fill" : "figure.strengthtraining.traditional")
                        }
                        .tag(1)

                    ExerciseLibraryView(dataService: dataService)
                        .tabItem {
                            Label("Exercícios", systemImage: selectedTab == 2 ? "dumbbell.fill" : "dumbbell")
                        }
                        .tag(2)

                    HistoryView(dataService: dataService)
                        .tabItem {
                            Label("Histórico", systemImage: selectedTab == 3 ? "clock.arrow.circlepath.fill" : "clock.arrow.circlepath")
                        }
                        .tag(3)

                    EvolutionView(dataService: dataService)
                        .tabItem {
                            Label("Evolução", systemImage: selectedTab == 4 ? "camera.viewfinder.fill" : "camera.viewfinder")
                        }
                        .tag(4)

                    StatisticsView(dataService: dataService)
                        .tabItem {
                            Label("Stats", systemImage: selectedTab == 5 ? "chart.bar.fill" : "chart.bar")
                        }
                        .tag(5)

                    ProfileView(dataService: dataService)
                        .tabItem {
                            Label("Perfil", systemImage: selectedTab == 6 ? "person.fill" : "person")
                        }
                        .tag(6)
                }
                .tint(.accentGreen)
            } else {
                ProgressView("Carregando...")
            }
        }
        .onAppear {
            let ds = DataService(modelContext: modelContext)
            dataService = ds
            SampleData.preloadIfNeeded(modelContext: modelContext)
            styleTabBar()
        }
    }

    private func styleTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
