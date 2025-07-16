import SwiftUI

struct DiagnosisResult {
    var label: String
    var riskLevel: RiskLevel
}

enum RiskLevel: String, Codable, CaseIterable {
    case safe
    case looking
    case dangerous
    
    var localized: LocalizedStringKey {
        switch self {
        case .safe: return "risklevel_safe"
        case .looking: return "risklevel_looking"
        case .dangerous: return "risklevel_dangerous"
        }
    }

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
