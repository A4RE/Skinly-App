import SwiftUI

struct ScanCase: Identifiable {
    let id: UUID
    var scans: [Scan]

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
