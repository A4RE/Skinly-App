import SwiftUI
import SwiftData

struct DiagnosisResult1 {
    let title: String
    let percentage: Int
    let recommendation: String
    let color: Color
}

struct ResultView: View {
    let image: UIImage
    let diagnosis: DiagnosisResult
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var isShowSavingSheet: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(alignment: .leading) {
                    createTitle()
                    createScrollView(geo: geo)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                createButtonsStack(geo: geo)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
            .padding(.horizontal)
            .background(Color.appBackground)
            .sheet(isPresented: $isShowSavingSheet) {
                SaveSheet { isNewCase in
                    if isNewCase {
                        saveNewScanCase(context: modelContext)
                    } else {
//                        saveResult(context: modelContext)
                    }
                    NotificationCenter.default.post(name: .didAddNewScan, object: nil)
                    dismiss()
                }
            }
        }
    }
    
    private func saveResult(context: ModelContext) {
        let scan = Scan(
            date: Date(),
            imageData: image.pngData()?.base64EncodedString() ?? "",
            diagnosisLabel: diagnosis.label,
            riskLevel: diagnosis.riskLevel
        )
        
        context.insert(scan)
        
        do {
            try context.save()
            print("Результат успешно сохранён.")
        } catch {
            print("Ошибка при сохранении результата: \(error.localizedDescription)")
        }
    }
    
    private func saveNewScanCase(context: ModelContext) {
        let scan = Scan(
            date: Date(),
            imageData: image.pngData()?.base64EncodedString() ?? "",
            diagnosisLabel: diagnosis.label,
            riskLevel: diagnosis.riskLevel
        )
        
        let scanCase = ScanCase(id: UUID(), scans: [scan])
        context.insert(scanCase)
        
        do {
            try context.save()
            print("Новый ScanCase успешно сохранён с одним Scan.")
        } catch {
            print("Ошибка при сохранении ScanCase: \(error.localizedDescription)")
        }
    }
    
    @ViewBuilder
    private func createTitle() -> some View {
        Text("Результат")
            .font(.largeTitle.bold())
            .foregroundColor(Color.appPrimaryText)
    }
    
    @ViewBuilder
    private func createScrollView(geo: GeometryProxy) -> some View {
        if geo.size.height < 737 {
            ScrollView(.vertical, showsIndicators: false) {
                createInfoContainer(geo: geo)
                    .padding(.bottom, 150)
            }
        } else {
            createInfoContainer(geo: geo)
        }
    }
    
    @ViewBuilder
    private func createInfoContainer(geo: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            Image(uiImage: image)
                .resizable()
                .frame(width: geo.size.height * 0.48, height: geo.size.height * 0.48)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            HStack(alignment: .center) {
                Text("Диагноз: ")
                    .font(.headline)
                    .foregroundColor(Color.appPrimaryText)
                
                Text("\(diagnosis.label)")
                    .font(.headline)
                    .foregroundColor(diagnosis.riskLevel.color)
                
                Image(systemName: diagnosis.riskLevel.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                    .foregroundColor(diagnosis.riskLevel.color)
            }
            
            HStack(alignment: .top) {
                Text("Рекомендация: ")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.appPrimaryText)
                Text("\(diagnosis.riskLevel.rawValue)")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color.appPrimaryText)
                
            }
            
            Text("⚠️ Внимание: Результаты анализа являются предварительными. Для постановки точного диагноза обязательно обратитесь к квалифицированному врачу.")
                .font(.subheadline)
                .foregroundColor(.appSecondaryText)
                .multilineTextAlignment(.center)
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    @ViewBuilder
    private func createButtonsStack(geo: GeometryProxy) -> some View {
        VStack(spacing: 16) {
            Button(action: {
                isShowSavingSheet = true
            }, label: {
                Text("Сохранить результат")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                    )
            })
            
            Button(action: {
                dismiss()
            }, label: {
                Text("Новое сканирование")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.appSecondaryText)
                    )
            })
        }
        .padding(.vertical)
        .background(Color.appBackground)
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(
            image: UIImage(named: "randomImg") ?? UIImage(),
            diagnosis: DiagnosisResult(
                label: "Мелонома",
                riskLevel: .looking
            )
        )
    }
}
