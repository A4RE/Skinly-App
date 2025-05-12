import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack {
            Spacer()
            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
            Spacer()
            Text("Skinly")
                .font(.system(size: 50, weight: .black))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.appPrimaryText)
                .offset(y: -100)
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity)
        .background(Color.appBackground)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                appState.isSplashShown = true
            }
        }
    }
}

#Preview {
    SplashScreenView()
        .environmentObject(AppState())
}
