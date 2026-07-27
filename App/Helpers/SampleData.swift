import Foundation
import SwiftData

final class SampleData {
    static func preloadIfNeeded(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<Exercise>()
        guard (try? modelContext.fetch(descriptor))?.isEmpty ?? true else { return }
        insertSampleExercises(modelContext: modelContext)
        insertSamplePreferences(modelContext: modelContext)
    }

    private static func insertSampleExercises(modelContext: ModelContext) {
        let exercises = [
            Exercise(name: "Supino Reto", muscleGroup: "Peito", exerciseDescription: "Exercício clássico para peitoral com barra.", equipment: "Barra", musclesWorked: "Peitoral maior, ombros, tríceps", imageName: "figure.strengthtraining.traditional"),
            Exercise(name: "Supino Inclinado", muscleGroup: "Peito", exerciseDescription: "Foco na parte superior do peitoral.", equipment: "Barra ou Halteres", musclesWorked: "Peitoral maior (clavicular), ombros", imageName: "figure.strengthtraining.traditional"),
            Exercise(name: "Crucifixo", muscleGroup: "Peito", exerciseDescription: "Isolamento do peitoral com halteres.", equipment: "Halteres", musclesWorked: "Peitoral maior", imageName: "figure.strengthtraining.traditional"),
            Exercise(name: "Puxada Alta", muscleGroup: "Costas", exerciseDescription: "Exercício para dorsais com barra ou triangulo.", equipment: "Polia", musclesWorked: "Latíssimo do dorso, bíceps", imageName: "figure.rower"),
            Exercise(name: "Remada Curvada", muscleGroup: "Costas", exerciseDescription: "Remada com barra para espessura das costas.", equipment: "Barra", musclesWorked: "Dorsais, romboides, trapézio", imageName: "figure.rower"),
            Exercise(name: "Remada Unilateral", muscleGroup: "Costas", exerciseDescription: "Remada com halteres, um braço de cada vez.", equipment: "Halteres", musclesWorked: "Dorsais, romboides", imageName: "figure.rower"),
            Exercise(name: "Desenvolvimento", muscleGroup: "Ombros", exerciseDescription: "Desenvolvimento de ombros com barra ou halteres.", equipment: "Barra ou Halteres", musclesWorked: "Deltoides, tríceps", imageName: "figure.boxing"),
            Exercise(name: "Elevação Lateral", muscleGroup: "Ombros", exerciseDescription: "Isolamento do deltoide lateral.", equipment: "Halteres", musclesWorked: "Deltoide lateral", imageName: "figure.boxing"),
            Exercise(name: "Elevação Frontal", muscleGroup: "Ombros", exerciseDescription: "Isolamento do deltoide frontal.", equipment: "Halteres ou Polia", musclesWorked: "Deltoide frontal", imageName: "figure.boxing"),
            Exercise(name: "Rosca Direta", muscleGroup: "Bíceps", exerciseDescription: "Rosca com barra para bíceps.", equipment: "Barra", musclesWorked: "Bíceps braquial", imageName: "figure.curling"),
            Exercise(name: "Rosca Martelo", muscleGroup: "Bíceps", exerciseDescription: "Rosca neutra para braquial e braquiorradial.", equipment: "Halteres", musclesWorked: "Braquial, braquiorradial", imageName: "figure.curling"),
            Exercise(name: "Rosca Scott", muscleGroup: "Bíceps", exerciseDescription: "Rosca no banco Scott para isolamento total.", equipment: "Barra W", musclesWorked: "Bíceps braquial", imageName: "figure.curling"),
            Exercise(name: "Tríceps Corda", muscleGroup: "Tríceps", exerciseDescription: "Extensão de tríceps na polia com corda.", equipment: "Polia", musclesWorked: "Tríceps braquial", imageName: "figure.core.training"),
            Exercise(name: "Tríceps Francês", muscleGroup: "Tríceps", exerciseDescription: "Extensão de tríceps deitado com barra.", equipment: "Barra W", musclesWorked: "Tríceps braquial", imageName: "figure.core.training"),
            Exercise(name: "Tríceps Testa", muscleGroup: "Tríceps", exerciseDescription: "Extensão de tríceps deitado com halteres.", equipment: "Halteres", musclesWorked: "Tríceps braquial", imageName: "figure.core.training"),
            Exercise(name: "Agachamento", muscleGroup: "Pernas", exerciseDescription: "Agachamento livre com barra.", equipment: "Barra", musclesWorked: "Quadríceps, glúteos, posteriores", imageName: "figure.walk"),
            Exercise(name: "Leg Press", muscleGroup: "Pernas", exerciseDescription: "Pressão de pernas na máquina.", equipment: "Máquina", musclesWorked: "Quadríceps, glúteos", imageName: "figure.walk"),
            Exercise(name: "Cadeira Extensora", muscleGroup: "Pernas", exerciseDescription: "Extensão de pernas na máquina.", equipment: "Máquina", musclesWorked: "Quadríceps", imageName: "figure.walk"),
            Exercise(name: "Mesa Flexora", muscleGroup: "Pernas", exerciseDescription: "Flexão de pernas na máquina.", equipment: "Máquina", musclesWorked: "Posteriores da coxa", imageName: "figure.walk"),
            Exercise(name: "Elevação Pélvica", muscleGroup: "Pernas", exerciseDescription: "Elevação de quadril com barra.", equipment: "Barra", musclesWorked: "Glúteos, posteriores", imageName: "figure.walk"),
            Exercise(name: "Panturrilha em Pé", muscleGroup: "Pernas", exerciseDescription: "Elevação de panturrilhas em pé.", equipment: "Máquina ou Barra", musclesWorked: "Gastrocnêmio, sóleo", imageName: "figure.walk"),
            Exercise(name: "Abdominal Crunch", muscleGroup: "Abdômen", exerciseDescription: "Crunch tradicional no solo.", equipment: "Peso corporal", musclesWorked: "Reto abdominal", imageName: "figure.core.training"),
            Exercise(name: "Prancha", muscleGroup: "Abdômen", exerciseDescription: "Prancha isométrica para core.", equipment: "Peso corporal", musclesWorked: "Core, reto abdominal, oblíquos", imageName: "figure.core.training"),
            Exercise(name: "Elevação de Pernas", muscleGroup: "Abdômen", exerciseDescription: "Elevação de pernas suspenso.", equipment: "Barras paralelas", musclesWorked: "Reto abdominal inferior", imageName: "figure.core.training"),
            Exercise(name: "Esteira", muscleGroup: "Cardio", exerciseDescription: "Corrida ou caminhada na esteira.", equipment: "Esteira", musclesWorked: "Sistema cardiovascular, pernas", imageName: "heart.fill"),
            Exercise(name: "Bicicleta", muscleGroup: "Cardio", exerciseDescription: "Ciclismo indoor ou outdoor.", equipment: "Bicicleta ou ergométrica", musclesWorked: "Sistema cardiovascular, pernas", imageName: "heart.fill"),
            Exercise(name: "Pular Corda", muscleGroup: "Cardio", exerciseDescription: "Pular corda para condicionamento.", equipment: "Corda", musclesWorked: "Sistema cardiovascular, panturrilhas", imageName: "heart.fill"),
        ]
        for exercise in exercises {
            modelContext.insert(exercise)
        }
        try? modelContext.save()
    }

    private static func insertSamplePreferences(modelContext: ModelContext) {
        let prefs = NotificationPreference()
        modelContext.insert(prefs)
        try? modelContext.save()
    }
}
