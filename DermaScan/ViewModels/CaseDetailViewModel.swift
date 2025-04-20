import SwiftUI

final class CaseDetailViewModel: ObservableObject {
    @Published var scans: [Scan] = []

    func loadCase(caseID: UUID) {
        // Заглушка для MVP: 
        // Здесь ты будешь доставать нужный кейс по ID из хранилища
        scans = [] 
    }

    func addNewScan(to caseID: UUID) {
        // Здесь будет логика добавления нового сканирования
        print("Добавить сканирование в кейс с ID: \(caseID)")
        // В реальной реализации ты вызовешь начало сканирования
    }
}
