import SwiftUI

struct HistoryListView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var viewModel: HistoryListViewModel
    
    var body: some View {
        ZStack {
            createListView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.appBackground)
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("scan_history")
                    .font(.headline.bold())
                    .foregroundColor(Color.appPrimaryText)
            }
        }
        .toolbarBackground(.white, for: .navigationBar)
        .onAppear {
            viewModel.loadCases(context: modelContext)
        }
        .ignoresSafeArea(edges: [.bottom, .horizontal])
    }
    
    
    @ViewBuilder
    private func createListView() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                ForEach(viewModel.scanCases.sorted(by: {$0.date > $1.date })) { scanCase in
                    HistoryItemView(scanCase: scanCase)
                        .background(Color.appBackground)
                        .padding(.horizontal)
                }
            }
        }
        .background(Color.appBackground)
    }
}
