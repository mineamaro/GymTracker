import Foundation

enum MuscleGroup: String, CaseIterable, Codable {
    case chest = "Peito"
    case back = "Costas"
    case shoulders = "Ombros"
    case biceps = "Bíceps"
    case triceps = "Tríceps"
    case legs = "Pernas"
    case abdomen = "Abdômen"
    case cardio = "Cardio"

    var iconName: String {
        switch self {
        case .chest: return "figure.strengthtraining.traditional"
        case .back: return "figure.rower"
        case .shoulders: return "figure.boxing"
        case .biceps: return "figure.curling"
        case .triceps: return "figure.core.training"
        case .legs: return "figure.walk"
        case .abdomen: return "figure.core.training"
        case .cardio: return "heart.fill"
        }
    }

    var colorName: String {
        switch self {
        case .chest: return "red"
        case .back: return "blue"
        case .shoulders: return "orange"
        case .biceps: return "purple"
        case .triceps: return "green"
        case .legs: return "yellow"
        case .abdomen: return "pink"
        case .cardio: return "teal"
        }
    }
}

enum Objective: String, CaseIterable, Codable {
    case hypertrophy = "Hipertrofia"
    case weightLoss = "Emagrecimento"
    case definition = "Definição"
    case strength = "Ganho de Força"
    case maintenance = "Manutenção"
}

enum Mood: String, CaseIterable, Codable {
    case great = "Ótimo"
    case good = "Bom"
    case neutral = "Normal"
    case bad = "Ruim"
    case terrible = "Péssimo"

    var emoji: String {
        switch self {
        case .great: return "😄"
        case .good: return "🙂"
        case .neutral: return "😐"
        case .bad: return "😕"
        case .terrible: return "😢"
        }
    }
}

enum EnergyLevel: String, CaseIterable, Codable {
    case high = "Alta"
    case medium = "Média"
    case low = "Baixa"
    case exhausted = "Esgotado"

    var iconName: String {
        switch self {
        case .high: return "bolt.fill"
        case .medium: return "bolt"
        case .low: return "zzz"
        case .exhausted: return "exclamationmark.triangle"
        }
    }
}

enum SetType: String, CaseIterable, Codable {
    case normal = "Normal"
    case warmup = "Aquecimento"
    case dropset = "Drop Set"
    case failure = "Até a Falha"
}
