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

                    EvolutionView(dataService: dataService)
                        .tabItem {
                            Label("Evolução", systemImage: selectedTab == 3 ? "camera.viewfinder.fill" : "camera.viewfinder")
                        }
                        .tag(3)

                    StatisticsView(dataService: dataService)
                        .tabItem {
                            Label("Stats", systemImage: selectedTab == 4 ? "chart.bar.fill" : "chart.bar")
                        }
                        .tag(4)

                    ProfileView(dataService: dataService)
                        .tabItem {
                            Label("Perfil", systemImage: selectedTab == 5 ? "person.fill" : "person")
                        }
                        .tag(5)
                }
                .tint(Color.neonGreen)
                .preferredColorScheme(.dark)
                .onAppear {
                    styleTabBar()
                }
            } else {
                ZStack {
                    Color.gymBackground.ignoresSafeArea()
                    ProgressView("CARREGANDO...")
                        .foregroundStyle(.white)
                }
            }
        }
        .onAppear {
            let ds = DataService(modelContext: modelContext)
            dataService = ds
            SampleData.preloadIfNeeded(modelContext: modelContext)
        }
    }

    private func styleTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.gymCard)
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.neonGreen)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(Color.neonGreen)]
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
