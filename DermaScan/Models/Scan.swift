import Foundation

struct Scan: Identifiable {
    let id: UUID
    var date: Date
    var imageData: String
    var diagnosis: DiagnosisResult
}

extension Scan {
    var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
