import SwiftUI

struct AnalyzingView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let image: UIImage
    @State private var isAnalysisComplete = false
    @State private var analysisStatusText = "Передаем изображение"
    @State private var progress: CGFloat = 0
    @State private var yPosition: CGFloat = 0
    @State private var isDownAnimation: Bool = false
    @State private var blurRadius: CGFloat = 11
    
    var onAnalizeFinished: (UIImage?) -> Void

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
                            .animation(.linear(duration: 13.5), value: progress)
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
                }
                
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(Color.appBackground)
            .onAppear {
                yPosition = geo.size.height * 0.635
                progress = UIScreen.main.bounds.width - 40

                moveRectangle(geo: geo)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        analysisStatusText = "Анализируем изображение"
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                    withAnimation {
                        analysisStatusText = "Предварительно обрабатываем"
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
                    withAnimation {
                        analysisStatusText = "Обрабатываем изображение"
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 7.5) {
                    withAnimation {
                        analysisStatusText = "Получаем результат"
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 9.5) {
                    withAnimation {
                        analysisStatusText = "Почти готово"
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 11.5) {
                    withAnimation {
                        analysisStatusText = "Завершаем"
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 13.5) {
                    isAnalysisComplete = true
                    onAnalizeFinished(image)
                    dismiss()
                    
                }
            }
        }
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

#Preview {
    AnalyzingView(image: UIImage(named: "randomImg")!, onAnalizeFinished: { _ in })
}
