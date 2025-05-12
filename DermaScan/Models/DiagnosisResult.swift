import SwiftUI

struct DiagnosisResult {
    var label: String
    var riskLevel: RiskLevel
}
enum RiskLevel: String, Codable {
    case safe = "Не беспокойтесь"
    case looking = "Наблюдайте"
    case dangerous = "Срочно обратитесь к специалисту"

    var color: Color {
        switch self {
        case .safe: return .green
        case .looking: return .yellow
        case .dangerous: return .red
        }
    }

    var icon: String {
        switch self {
        case .safe: return "checkmark.circle.fill"
        case .looking: return "exclamationmark.triangle.fill"
        case .dangerous: return "xmark.seal.fill"
        }
    }
}
