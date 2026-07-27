import SwiftUI

struct DashboardView: View {
    @State private var viewModel: DashboardViewModel

    init(dataService: DataService) {
        _viewModel = State(initialValue: DashboardViewModel(dataService: dataService))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    headerSection
                    workoutStatusSection
                    statsGridSection
                    if let goal = viewModel.activeGoal {
                        activeGoalSection(goal)
                    }
                    recentSessionsSection
                }
                .padding()
            }
            .background(Color(.systemBackground))
            .navigationTitle("Início")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { viewModel.refresh() }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(viewModel.userName.isEmpty ? "Bem-vindo!" : "Olá, \(viewModel.userName)!")
                .font(.title2)
                .fontWeight(.bold)

            if viewModel.currentStreak > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(.accentOrange)
                    Text("\(viewModel.currentStreak) dias seguidos!")
                }
                .font(.subheadline)
                .foregroundStyle(.accentOrange)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private var workoutStatusSection: some View {
        if let session = viewModel.todayWorkout, session.endTime == nil {
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Treino em Andamento")
                            .font(.headline)
                        Text("Iniciado às \(session.startTime.formattedTime())")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Button(action: { viewModel.finishTodayWorkout() }) {
                        Text("Finalizar")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.accentRed)
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                    }
                }

                HStack(spacing: 20) {
                    StatCard(title: "Exercícios", value: "\(viewModel.todayExercises)", icon: "dumbbell.fill", color: .accentBlue)
                    StatCard(title: "Séries", value: "\(viewModel.todaySets)", icon: "list.bullet", color: .accentPurple)
                    StatCard(title: "Volume", value: String(format: "%.0f kg", viewModel.todayVolume), icon: "scalemass", color: .accentGreen)
                    StatCard(title: "Tempo", value: viewModel.workoutDuration.formattedDuration(), icon: "clock", color: .accentOrange)
                }
            }
            .padding()
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        } else {
            Button(action: { viewModel.startWorkout() }) {
                HStack {
                    Image(systemName: "play.fill")
                    Text("Iniciar Treino")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentGreen)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }

    private var statsGridSection: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
            StatCard(title: "Treinos Essa Semana", value: "\(viewModel.currentStreak)", icon: "calendar.badge.clock", color: .accentBlue)
            StatCard(title: "Recorde de Dias", value: "\(viewModel.currentStreak)", icon: "flame.fill", color: .accentOrange)
            StatCard(title: "Volume Total Hoje", value: String(format: "%.0f kg", viewModel.todayVolume), icon: "scalemass.fill", color: .accentGreen)
            StatCard(title: "Exercícios Hoje", value: "\(viewModel.todayExercises)", icon: "figure.strengthtraining.traditional", color: .accentPurple)
        }
    }

    private func activeGoalSection(_ goal: Goal) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "target")
                    .foregroundStyle(.accentBlue)
                Text("Meta Ativa")
                    .font(.headline)
                Spacer()
            }
            Text(goal.title)
                .font(.body)
                .fontWeight(.medium)
            ProgressBarView(progress: goal.progress)
        }
        .padding()
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var recentSessionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Últimos Treinos")
                .font(.headline)

            if viewModel.recentSessions.isEmpty {
                EmptyStateView(icon: "figure.strengthtraining.traditional", title: "Nenhum treino ainda",
                               message: "Seus treinos registrados aparecerão aqui.")
            } else {
                ForEach(viewModel.recentSessions) { session in
                    WorkoutCard(session: session)
                }
            }
        }
    }
}
