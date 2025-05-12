import SwiftData
import Foundation

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

    var latestDiagnosis: String? {
        scans.last?.diagnosis.label
    }

    var latestDateFormatted: String {
        guard let date = scans.last?.date else { return "Неизвестно" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
