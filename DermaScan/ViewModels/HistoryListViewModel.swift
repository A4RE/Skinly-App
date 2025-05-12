import SwiftUI
import SwiftData

final class HistoryListViewModel: ObservableObject {
    @Published var scanCases: [ScanCase] = []

    func loadCases(context: ModelContext) {
        let descriptor = FetchDescriptor<ScanCase>(
            sortBy: [SortDescriptor(\.id)]
        )

        do {
            scanCases = try context.fetch(descriptor)
        } catch {
            print("Ошибка загрузки ScanCase: \(error)")
        }
    }
    
    var statistics: ProfileStatistics {
        let allScans = scanCases.flatMap { $0.scans }
        
        let safe = allScans.filter { $0.diagnosis.riskLevel == .safe }.count
        let monitor = allScans.filter { $0.diagnosis.riskLevel == .looking }.count
        let danger = allScans.filter { $0.diagnosis.riskLevel == .dangerous }.count
        
        return ProfileStatistics(
            totalScans: allScans.count,
            safeScans: safe,
            monitorScans: monitor,
            dangerousScans: danger
        )
    }
}
