import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var viewModel: ProfileViewModel
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Профиль: \(viewModel.userName)")
                    .font(.title2.bold())
                    .foregroundStyle(Color.appPrimaryText)
                
                StatisticsView(statistics: viewModel.statistics)
                
                NavigationLink(destination: HistoryListView()) {
                    Text("История сканирований")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.appAccent)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }

                Spacer()
            }
            .padding()
            .background(Color.appBackground)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(ProfileViewModel())
        .environmentObject(HistoryListViewModel())
}
