import SwiftData
import Foundation
import SwiftUI

@Model
class ScanCase {
    @Attribute(.unique) var id: UUID
    var scans: [Scan] = []

    init(id: UUID = UUID(), scans: [Scan] = []) {
        self.id = id
        self.scans = scans
    }

    var firstImageData: String? {
        scans.first?.imageData
    }

    var latestDiagnosis: String {
        scans.last?.diagnosis.label ?? "unkonwn"
    }

    var latestDateFormatted: String {
        guard let date = scans.last?.date else { return "unkonwn" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    var latestDiagonsis: LocalizedStringKey {
        scans.last?.diagnosis.riskLevel.localized ?? "warning"
    }
    
    var date: Date {
        guard let date = scans.first?.date else { return Date()}
        return date
    }
}
