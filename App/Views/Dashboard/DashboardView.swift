import SwiftUI

struct DashboardView: View {
    @State private var viewModel: DashboardViewModel

    init(dataService: DataService) {
        _viewModel = State(initialValue: DashboardViewModel(dataService: dataService))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.gymBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        heroSection
                        workoutStatusSection
                        statsGridSection
                        if let goal = viewModel.activeGoal { activeGoalSection(goal) }
                        recentSessionsSection
                    }
                    .padding()
                }
            }
            .navigationTitle("🏋️ INÍCIO")
            .toolbarBackground(Color.gymCard, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { viewModel.refresh() }) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundStyle(Color.neonGreen)
                    }
                }
            }
        }
    }

    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(viewModel.userName.isEmpty ? "BEM-VINDO!" : "OLÁ, \(viewModel.userName.uppercased())!")
                .font(.title2).fontWeight(.heavy)
                .foregroundStyle(.white)

            if viewModel.currentStreak > 0 {
                HStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(Color.neonOrange)
                        .neonGlow(color: .neonOrange, radius: 6)
                    Text("🔥 \(viewModel.currentStreak) DIAS SEGUIDOS!")
                        .font(.subheadline).fontWeight(.bold)
                        .foregroundStyle(Color.neonOrange)
                }
            }

            Text("VAMOS TREINAR! 💪")
                .font(.caption).fontWeight(.bold)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            LinearGradient(colors: [Color.gymCard, Color.gymCardLight], startPoint: .top, endPoint: .bottom)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.neonGreen.opacity(0.15), lineWidth: 1))
    }

    @ViewBuilder
    private var workoutStatusSection: some View {
        if let session = viewModel.todayWorkout, session.endTime == nil {
            VStack(spacing: 14) {
                HStack {
                    HStack(spacing: 8) {
                        Circle().fill(Color.neonGreen).frame(width: 8, height: 8)
                            .neonGlow(color: .neonGreen, radius: 4)
                        Text("TREINO EM ANDAMENTO")
                            .font(.headline).fontWeight(.bold)
                            .foregroundStyle(Color.neonGreen)
                    }
                    Spacer()
                    Button(action: { viewModel.finishTodayWorkout() }) {
                        Text("FINALIZAR")
                            .font(.caption).fontWeight(.heavy)
                            .padding(.horizontal, 16).padding(.vertical, 8)
                            .background(Color.neonRed)
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                            .neonGlow(color: .neonRed, radius: 5)
                    }
                }

                HStack(spacing: 0) {
                    gymMiniStat("EXERCÍCIOS", "\(viewModel.todayExercises)", .neonBlue)
                    Divider().frame(height: 40).background(Color.gymBorder)
                    gymMiniStat("SÉRIES", "\(viewModel.todaySets)", .neonPurple)
                    Divider().frame(height: 40).background(Color.gymBorder)
                    gymMiniStat("VOLUME", String(format: "%.0f", viewModel.todayVolume), .neonGreen)
                    Divider().frame(height: 40).background(Color.gymBorder)
                    gymMiniStat("TEMPO", viewModel.workoutDuration.formattedDuration(), .neonOrange)
                }
            }
            .padding()
            .background(Color.gymCard)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.neonGreen.opacity(0.2), lineWidth: 1))
        } else {
            Button(action: { viewModel.startWorkout() }) {
                HStack(spacing: 12) {
                    Image(systemName: "play.fill")
                        .font(.title3)
                        .neonGlow(color: .neonGreen, radius: 8)
                    Text("INICIAR TREINO")
                        .fontWeight(.heavy).font(.title3)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(
                    LinearGradient(colors: [Color.neonGreen.opacity(0.15), Color.neonGreen.opacity(0.05)], startPoint: .leading, endPoint: .trailing)
                )
                .foregroundStyle(Color.neonGreen)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.neonGreen.opacity(0.3), lineWidth: 1))
                .neonGlow(color: .neonGreen, radius: 6)
            }
        }
    }

    private func gymMiniStat(_ label: String, _ value: String, _ color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3).fontWeight(.heavy)
                .foregroundStyle(color)
            Text(label)
                .font(.system(size: 8)).fontWeight(.bold)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
    }

    private var statsGridSection: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
            gymStatCard("TREINOS / SEMANA", "\(viewModel.currentStreak)", "calendar.badge.clock", .neonBlue)
            gymStatCard("SEQUÊNCIA", "\(viewModel.currentStreak) DIAS", "flame.fill", .neonOrange)
            gymStatCard("VOLUME HOJE", String(format: "%.0f KG", viewModel.todayVolume), "scalemass.fill", .neonGreen)
            gymStatCard("EXERCÍCIOS", "\(viewModel.todayExercises)", "figure.strengthtraining.traditional", .neonPurple)
        }
    }

    private func gymStatCard(_ title: String, _ value: String, _ icon: String, _ color: Color) -> some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
                .neonGlow(color: color, radius: 6)
            Text(value)
                .font(.title3).fontWeight(.heavy)
                .foregroundStyle(.white)
                .minimumScaleFactor(0.7)
            Text(title)
                .font(.system(size: 8)).fontWeight(.bold)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.gymCard)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(color.opacity(0.2), lineWidth: 1))
    }

    private func activeGoalSection(_ goal: Goal) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "target")
                    .foregroundStyle(Color.neonGreen)
                    .neonGlow(color: .neonGreen, radius: 4)
                Text("META ATIVA").font(.headline).fontWeight(.bold).foregroundStyle(.white)
                Spacer()
            }
            Text(goal.title.uppercased())
                .font(.body).fontWeight(.semibold).foregroundStyle(.white)
            ProgressBarView(progress: goal.progress, color: .neonGreen)
        }
        .padding()
        .background(Color.gymCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gymBorder, lineWidth: 1))
    }

    private var recentSessionsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("ÚLTIMOS TREINOS")
                .font(.headline).fontWeight(.bold).foregroundStyle(.white)

            if viewModel.recentSessions.isEmpty {
                EmptyStateView(icon: "figure.strengthtraining.traditional",
                              title: "NENHUM TREINO AINDA",
                              message: "Seus treinos registrados aparecerão aqui.")
            } else {
                ForEach(viewModel.recentSessions, id: \.id) { session in
                    WorkoutCard(session: session)
                }
            }
        }
    }
}
