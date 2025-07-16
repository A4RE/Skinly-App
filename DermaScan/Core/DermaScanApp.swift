import SwiftUI

@main
struct DermaScanApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var historyViewModel = HistoryListViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    
    var body: some Scene {
        WindowGroup {
            if appState.isSplashShown {
                HomeView()
                    .environmentObject(appState)
                    .environmentObject(historyViewModel)
                    .environmentObject(profileViewModel)
                    .environment(\.colorScheme, .light)
            } else {
                SplashScreenView()
                    .environmentObject(appState)
                    .environment(\.colorScheme, .light)
            }
        }
        .modelContainer(for: [ScanCase.self, Scan.self])
    }
}
