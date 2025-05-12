import SwiftUI

struct CaseDetailView: View {
    let scans: [Scan]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ForEach(scans, id: \.id) { scan in
                            ScanItemView(scan: scan)
                        }
                    }
                    .padding(.vertical)
                    .padding(.horizontal)
                }
                .padding(.top, 100)
                .padding(.bottom, 100)
                Button(action: {
                    //                    viewModel.addNewScan(to: caseID)
                }) {
                    Text("Добавить сканирование")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.appAccent)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
                .offset(y: geometry.size.height * 0.43)

            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
            .navigationTitle("Детали кейса")
            .background(Color.appBackground)
        }
        .ignoresSafeArea(.all)
    }
}

//#Preview {
//    CaseDetailView(scans:
//                    Array(repeating: Scan(id: UUID(), date: Date(), imageData: "randomImg", diagnosis: DiagnosisResult(label: "мелонома", riskLevel: .dangerous)), count: 20))
//}
