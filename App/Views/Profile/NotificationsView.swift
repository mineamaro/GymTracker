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
            Form {
                Section("Lembretes") {
                    Toggle("Hora do Treino", isOn: $workoutEnabled)
                    if workoutEnabled {
                        DatePicker("Horário", selection: $workoutTime, displayedComponents: .hourAndMinute)
                    }

                    Toggle("Registrar Peso", isOn: $weightEnabled)

                    Toggle("Tirar Foto do Shape", isOn: $photoEnabled)

                    Toggle("Beber Água", isOn: $waterEnabled)
                    if waterEnabled {
                        VStack {
                            HStack {
                                Text("Intervalo")
                                Spacer()
                                Text("\(Int(waterInterval)) min")
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: $waterInterval, in: 15...180, step: 15)
                                .tint(Color.accentBlue)
                        }
                    }
                }

                Section("Temporizador") {
                    VStack {
                        HStack {
                            Text("Descanso Padrão")
                            Spacer()
                            Text(formatDuration(Int(restTimerDuration)))
                                .foregroundStyle(.secondary)
                        }
                        Slider(value: $restTimerDuration, in: 30...300, step: 15)
                            .tint(Color.accentOrange)
                    }
                }

                Section {
                    Button("Salvar Preferências") {
                        savePreferences()
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .fontWeight(.semibold)
                }
            }
            .navigationTitle("Notificações")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Fechar") { dismiss() }
                }
            }
            .onAppear(perform: loadPreferences)
        }
    }

    private func loadPreferences() {
        // Would load from DataService in production
    }

    private func savePreferences() {
        let service = NotificationService.shared
        service.requestAuthorization()

        if workoutEnabled {
            service.scheduleWorkoutReminder(at: workoutTime)
        } else {
            service.removeWorkoutReminder()
        }

        if weightEnabled {
            service.scheduleWeightReminder()
        } else {
            service.removeWeightReminder()
        }

        if photoEnabled {
            service.schedulePhotoReminder()
        } else {
            service.removePhotoReminder()
        }

        if waterEnabled {
            service.scheduleWaterReminder(intervalMinutes: Int(waterInterval))
        } else {
            service.removeWaterReminder()
        }
    }

    private func formatDuration(_ seconds: Int) -> String {
        if seconds >= 60 {
            return "\(seconds / 60)min \(seconds % 60)s"
        }
        return "\(seconds)s"
    }
}
