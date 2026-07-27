import SwiftUI

struct NotificationsView: View {
    @State private var workoutEnabled = true
    @State private var workoutTime = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var weightEnabled = false
    @State private var photoEnabled = false
    @State private var waterEnabled = false
    @State private var waterInterval: Double = 60
    @State private var restTimerDuration: Double = 90

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.gymBackground.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 24) {
                        settingsSection("🔔 LEMBRETES") {
                            gymToggle("HORA DO TREINO", isOn: $workoutEnabled)
                            if workoutEnabled {
                                DatePicker("HORÁRIO", selection: $workoutTime, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(.compact)
                                    .tint(Color.neonGreen)
                                    .colorScheme(.dark)
                            }
                            gymToggle("REGISTRAR PESO", isOn: $weightEnabled)
                            gymToggle("📸 TIRAR FOTO DO SHAPE", isOn: $photoEnabled)
                            gymToggle("💧 BEBER ÁGUA", isOn: $waterEnabled)
                            if waterEnabled {
                                VStack(spacing: 8) {
                                    HStack {
                                        Text("INTERVALO").font(.caption).fontWeight(.bold).foregroundStyle(.gray)
                                        Spacer()
                                        Text("\(Int(waterInterval)) MIN").fontWeight(.bold).foregroundStyle(.white)
                                    }
                                    Slider(value: $waterInterval, in: 15...180, step: 15)
                                        .tint(Color.neonBlue)
                                }
                            }
                        }

                        settingsSection("⏱ TEMPORIZADOR") {
                            VStack(spacing: 8) {
                                HStack {
                                    Text("DESCANSO PADRÃO").font(.caption).fontWeight(.bold).foregroundStyle(.gray)
                                    Spacer()
                                    Text(formatDuration(Int(restTimerDuration))).fontWeight(.bold).foregroundStyle(.white)
                                }
                                Slider(value: $restTimerDuration, in: 30...300, step: 15)
                                    .tint(Color.neonOrange)
                            }
                        }

                        Button(action: saveAndDismiss) {
                            Text("💾 SALVAR PREFERÊNCIAS")
                                .fontWeight(.heavy)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.neonGreen.opacity(0.15))
                                .foregroundStyle(Color.neonGreen)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.neonGreen.opacity(0.3), lineWidth: 1))
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("🔔 NOTIFICAÇÕES")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.gymCard, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("FECHAR") { dismiss() }
                        .fontWeight(.bold).foregroundStyle(Color.neonGreen)
                }
            }
        }
    }

    private func settingsSection(_ title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.headline).fontWeight(.bold)
                .foregroundStyle(.white)
            content()
        }
        .padding()
        .background(Color.gymCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gymBorder, lineWidth: 1))
    }

    private func gymToggle(_ label: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(label)
                .font(.subheadline).fontWeight(.bold)
                .foregroundStyle(.white)
            Spacer()
            Toggle("", isOn: isOn)
                .tint(Color.neonGreen)
        }
    }

    private func saveAndDismiss() {
        let service = NotificationService.shared
        service.requestAuthorization()

        if workoutEnabled { service.scheduleWorkoutReminder(at: workoutTime) }
        else { service.removeWorkoutReminder() }
        if weightEnabled { service.scheduleWeightReminder() }
        else { service.removeWeightReminder() }
        if photoEnabled { service.schedulePhotoReminder() }
        else { service.removePhotoReminder() }
        if waterEnabled { service.scheduleWaterReminder(intervalMinutes: Int(waterInterval)) }
        else { service.removeWaterReminder() }

        dismiss()
    }

    private func formatDuration(_ seconds: Int) -> String {
        seconds >= 60 ? "\(seconds / 60)MIN \(seconds % 60)S" : "\(seconds)S"
    }
}
