import SwiftUI

struct HistoryListView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var viewModel: HistoryListViewModel
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 0) {
                    createListView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.appBackground)
                .navigationTitle("")
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("История сканирований")
                            .font(.headline.bold())
                            .foregroundColor(Color.appPrimaryText)
                    }
                }
                .onAppear {
                    viewModel.loadCases(context: modelContext)
                }
                Rectangle()
                    .fill(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .offset(y: -120)
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
    }
    
    @ViewBuilder
    private func createEmptyView(geo: GeometryProxy) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "list.bullet.clipboard.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(Color.appSecondaryText)
                .frame(height: geo.size.height * 0.2)
            Text("История сканирований\nпуста")
                .multilineTextAlignment(.center)
                .font(.title2.bold())
                .foregroundColor(Color.appSecondaryText)
        }
    }
    
    
    @ViewBuilder
    private func createListView() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 10) {
                ForEach(viewModel.scanCases) { scanCase in
                    NavigationLink(destination: CaseDetailView(scans: scanCase.scans)) {
                        HistoryItemView(scanCase: scanCase)
                            .background(Color.appBackground)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 8)
        }
        .background(Color.appBackground.ignoresSafeArea())
        .padding(.horizontal)
    }
}
