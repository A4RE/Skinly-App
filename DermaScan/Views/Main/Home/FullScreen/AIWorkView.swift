import SwiftUI

struct AnalyzingView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let image: UIImage
    @State private var analysisStatusText: LocalizedStringKey = "sending_image"
    @State private var progress: CGFloat = 0
    @State private var yPosition: CGFloat = 0
    @State private var isDownAnimation: Bool = false
    @State private var blurRadius: CGFloat = 11
    @State private var pendingResult: DiagnosisResult? = nil
    @State private var hasStartedAnalysis = false
    
    var onAnalizeFinished: (UIImage?, DiagnosisResult) -> Void

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 100) {
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: geo.size.height * 0.48, height: geo.size.height * 0.48)
                        .clipped()
                        .blur(radius: blurRadius)
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.5))
                        .frame(height: 5)
                        .position(x: geo.size.width / 2, y: yPosition)
                }

                VStack(spacing: 24) {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black.opacity(0.5), lineWidth: 2)
                            .frame(height: 20)
                        
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue)
                            .frame(width: progress, height: 20)
                            .animation(.linear(duration: 2.0), value: progress)
                    }
                    .padding(.horizontal, 20)

                    HStack(spacing: 12) {
                        Text(analysisStatusText)
                            .font(.headline)
                            .foregroundColor(.black)
                            .transition(.opacity)
                            .animation(.easeInOut, value: analysisStatusText)

                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    }
                    .padding(.bottom)
                }
                
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(Color.appBackground)
            .onAppear {
                
                guard !hasStartedAnalysis else { return }
                hasStartedAnalysis = true
                
                yPosition = geo.size.height * 0.635
                progress = UIScreen.main.bounds.width - 40

                moveRectangle(geo: geo)
                
                if let analyzer = SkinAnalyzer() {
                    analyzer.analyze(image: image) { label, rawScores in
                        let probabilities = softmax(rawScores)

                        if let topLabel = label, let topProb = probabilities[topLabel] {
                            let topPercent = Int(topProb * 100)
                            print("🏆 Top result: \(topLabel) — \(topPercent)%")
                        } else {
                            print("🏆 Top result: неизвестно")
                        }

                        print("📊 All probabilities:")
                        for (cls, prob) in probabilities
                            .sorted(by: { $0.value > $1.value }) {
                            let percent = Int(prob * 100)
                            print("  • \(cls): \(percent)%")
                        }
                        let result = DiagnosisResult(label: label ?? "unknown",
                                                     riskLevel: .looking)
                        DispatchQueue.main.async {
                            self.pendingResult = renameDiagnosis(diagnos: result)
                        }
                    }
                    
                } else {
                    self.pendingResult = DiagnosisResult(label: "model_error",
                                                         riskLevel: .looking)
                }
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        analysisStatusText = "analyzing_image"
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation {
                        analysisStatusText = "processing_image"
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        analysisStatusText = "getting_result"
                    }
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    onAnalizeFinished(image, pendingResult ?? DiagnosisResult(label: "unkown", riskLevel: .looking))
                    
                }
            }
        }
    }
    
    private func renameDiagnosis(diagnos: DiagnosisResult) -> DiagnosisResult {
        switch diagnos.label {
        case "actinic_keratosis":
            return DiagnosisResult(label: diagnos.label, riskLevel: .dangerous)
        case "basal_cell_carcinoma":
            return DiagnosisResult(label: diagnos.label, riskLevel: .dangerous)
        case "eczema_dermatitis":
            return DiagnosisResult(label: diagnos.label, riskLevel: .looking)
        case "infectious":
            return DiagnosisResult(label: diagnos.label, riskLevel: .looking)
        case "melanoma":
            return DiagnosisResult(label: diagnos.label, riskLevel: .dangerous)
        case "nevus":
            return DiagnosisResult(label: diagnos.label, riskLevel: .safe)
        case "psoriasis":
            return DiagnosisResult(label: diagnos.label, riskLevel: .looking)
        case "seborrheic_keratosis":
            return DiagnosisResult(label: diagnos.label, riskLevel: .safe)
        case "squamous_cell_carcinoma":
            return DiagnosisResult(label: diagnos.label, riskLevel: .dangerous)
        default:
            return DiagnosisResult(label: diagnos.label, riskLevel: .looking)
        }
    }
    
    func softmax(_ logits: [String: Float]) -> [String: Float] {
        let exps = logits.mapValues { Foundation.exp($0) }
        let sumExp = exps.values.reduce(0, +)
        return exps.mapValues { $0 / sumExp }
    }
    
    private func moveRectangle(geo: GeometryProxy) {
        withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: true)) {
            if isDownAnimation {
                yPosition = geo.size.height * 0.635
            } else {
                yPosition = geo.size.height * 0.15
            }
        }
        
        for _ in 0...10 {
            withAnimation(.linear(duration: 6)) {
                blurRadius -= 1
            }
        }
    }
}
