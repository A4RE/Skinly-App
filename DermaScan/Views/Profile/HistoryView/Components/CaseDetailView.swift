import SwiftUI

struct CaseDetailView: View {
    let scans: [Scan]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                List(scans) { scan in
                    ScanItemView(scan: scan)
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden, axes: .vertical)
                .scrollContentBackground(.hidden)
                .background(Color.appBackground)
                
                Button(action: {
//                    viewModel.addNewScan(to: caseID)
                }) {
                    Text("Добавить сканирование")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.appAccent)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding()
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.92)
            }
            .navigationTitle("Детали кейса")
            .background(Color.appBackground)
        }
    }
}

#Preview {
    CaseDetailView(scans: [
        Scan(id: UUID(), date: Date(), imageData: "randomImg", diagnosis: DiagnosisResult(label: "Мелонома", riskLevel: .dangerous))
    ])
}
