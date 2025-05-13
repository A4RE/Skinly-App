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
                
                Rectangle()
                    .fill(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .offset(y: -20)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Детали сканирования")
                        .font(.headline.bold())
                        .foregroundColor(Color.appPrimaryText)
                }
            }
            .background(Color.appBackground)
        }
        .ignoresSafeArea(.all)
    }
}

//#Preview {
//    CaseDetailView(scans:
//                    Array(repeating: Scan(id: UUID(), date: Date(), imageData: "randomImg", diagnosis: DiagnosisResult(label: "мелонома", riskLevel: .dangerous)), count: 20))
//}
