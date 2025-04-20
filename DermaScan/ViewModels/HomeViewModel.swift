import SwiftUI

enum ScanMode {
    case new
    case append
}

final class HomeViewModel: ObservableObject {
    @Published var showSourceSelectionSheet: Bool = false
    @Published var selectedScanMode: ScanMode? = nil
}
