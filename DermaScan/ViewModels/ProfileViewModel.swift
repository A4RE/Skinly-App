import SwiftUI

final class ProfileViewModel: ObservableObject {
    @Published var userName: String = ""
    @Published var statistics: ProfileStatistics = .empty

    init() {
        loadProfile()
        loadStatistics()
    }

    private func loadProfile() {
        // В реальном приложении здесь будет загрузка имени пользователя из UserDefaults или генерация
        if let savedName = UserDefaults.standard.string(forKey: "userName") {
            userName = savedName
        } else {
            let newName = "User-\(UUID().uuidString.prefix(8))"
            userName = String(newName)
            UserDefaults.standard.set(userName, forKey: "userName")
        }
    }

    private func loadStatistics() {
        // Здесь будет логика загрузки статистики из сохранённой истории
        // Для MVP можно оставить заглушку
        statistics = ProfileStatistics(totalScans: 0, safeScans: 0, monitorScans: 0, dangerousScans: 0)
    }
}

// Вспомогательная структура для статистики
struct ProfileStatistics {
    var totalScans: Int
    var safeScans: Int
    var monitorScans: Int
    var dangerousScans: Int

    static var empty: ProfileStatistics {
        ProfileStatistics(totalScans: 0, safeScans: 0, monitorScans: 0, dangerousScans: 0)
    }
}
