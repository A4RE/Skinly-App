import SwiftUI

final class ProfileViewModel: ObservableObject {
    @Published var userName: String = ""
    @Published var statistics: ProfileStatistics = .empty
    @Published var scans: [Scan] = []

    init() {
        loadProfile()
    }

    private func loadProfile() {
        if let savedName = UserDefaults.standard.string(forKey: "userName") {
            userName = savedName
        } else {
            let newName = "User-\(UUID().uuidString.prefix(8))"
            userName = String(newName)
            UserDefaults.standard.set(userName, forKey: "userName")
        }
    }
    
    func updateStatistics(from history: HistoryListViewModel) {
        statistics = history.statistics
    }
}
