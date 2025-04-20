import SwiftUI

@main
struct DermaScanApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var historyViewModel = HistoryListViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    
    var body: some Scene {
        WindowGroup {
            if appState.isSplashShown {
                MainTabView()
                    .environmentObject(appState)
                    .environmentObject(historyViewModel)
                    .environmentObject(profileViewModel)
            } else {
                SplashScreenView()
                    .environmentObject(appState)
            }
        }
    }
}
