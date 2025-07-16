import SwiftUI

final class ProfileViewModel: ObservableObject {
    @Published var statistics: ProfileStatistics = .empty
    @Published var scans: [Scan] = []
    
    func updateStatistics(from history: HistoryListViewModel) {
        statistics = history.statistics
    }
}
