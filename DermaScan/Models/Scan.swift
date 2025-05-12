import SwiftData
import Foundation

@Model
class Scan {
    @Attribute(.unique) var id: UUID
    var date: Date
    var imageData: String
    var diagnosisLabel: String
    var riskLevelRaw: String

    init(id: UUID = UUID(), date: Date, imageData: String, diagnosisLabel: String, riskLevel: RiskLevel) {
        self.id = id
        self.date = date
        self.imageData = imageData
        self.diagnosisLabel = diagnosisLabel
        self.riskLevelRaw = riskLevel.rawValue
    }

    var diagnosis: DiagnosisResult {
        DiagnosisResult(label: diagnosisLabel, riskLevel: RiskLevel(rawValue: riskLevelRaw) ?? .safe)
    }
}
