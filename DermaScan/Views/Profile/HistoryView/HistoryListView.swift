import SwiftUI

struct HistoryListView: View {
    @EnvironmentObject private var viewModel: HistoryListViewModel
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                if viewModel.scanCases.isEmpty {
                    createEmptyView(geo: geo)
                } else {
                    createListView()
//                    createEmptyView(geo: geo)
                }
                
                createButton(geo: geo)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.appBackground)
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Text("История сканирований")
                        .font(.headline.bold())
                        .foregroundColor(Color.appPrimaryText)
                }
            }
            .onAppear {
                viewModel.loadCases()
            }
        }
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
    
    // TODO: Разобраться почему у ряда в листе черный цвето
    @ViewBuilder
    private func createListView() -> some View {
        List(viewModel.scanCases) { scanCase in
            NavigationLink(destination: CaseDetailView(scans: scanCase.scans)) {
                HistoryItemView(scanCase: scanCase)
            }
            .background(Color.appBackground)
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden, axes: .vertical)
        .scrollContentBackground(.hidden)
    }
    
    @ViewBuilder
    private func createButton(geo: GeometryProxy) -> some View {
        Button(action: {
            //                viewModel.addNewScan(to: caseID)
        }) {
            Text("Новое сканирование")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.appAccent)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding()
        }
    }
}

#Preview {
    NavigationStack {
        HistoryListView()
            .environmentObject(HistoryListViewModel())
    }
}
