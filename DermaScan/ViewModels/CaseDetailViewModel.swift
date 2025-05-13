import SwiftUI

final class CaseDetailViewModel: ObservableObject {
    @Published var scans: [Scan] = []

    func loadCase(caseID: UUID) {
        scans = [] 
    }
}
