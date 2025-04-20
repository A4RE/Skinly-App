import SwiftUI

final class HistoryListViewModel: ObservableObject {
    @Published var scanCases: [ScanCase] = []

    func loadCases() {
        // Заглушка для MVP
        for _ in 0..<50 {
            scanCases.append(ScanCase(id: UUID(), scans: [
                Scan(id: UUID(), date: Date(), imageData: "randomImg", diagnosis: DiagnosisResult(label: "Мелонома", riskLevel: .dangerous))
            ]))
        }
//        scanCases = [] // Здесь будешь потом подгружать из StorageService
    }
}
