import SwiftUI

struct SourceSelectionSheet: View {
    @ObservedObject var viewModel: HomeViewModel
    var onSelectSource: (ImageSource) -> Void
    
    let size = UIScreen.main.bounds.size

    var body: some View {
        ZStack {
            Color.appBackground
            VStack(spacing: 24) {
                Text("Выберите источник")
                    .foregroundStyle(Color.appPrimaryText)
                    .font(.title2.bold())
                    .padding(.top, 15)
                
                Button(action: {
                    onSelectSource(.camera)
                    viewModel.showSourceSelectionSheet = false
                }) {
                    Text("Камера")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.appAccent)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
                
                Button(action: {
                    onSelectSource(.gallery)
                    viewModel.showSourceSelectionSheet = false
                }) {
                    Text("Галерея")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.appSecondaryBackground)
                        .foregroundColor(.appPrimaryText)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
                
                Button(action: {
                    onSelectSource(.files)
                    viewModel.showSourceSelectionSheet = false
                }) {
                    Text("Файлы")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.appSecondaryBackground)
                        .foregroundColor(.appPrimaryText)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
                
                Button(action: {
                    viewModel.showSourceSelectionSheet = false
                }) {
                    Text("Закрыть")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.appSecondaryBackground)
                        .foregroundColor(.appPrimaryText)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .presentationDetents([.fraction(size.height < 737 ? 0.6 : 0.48)])
        .presentationCornerRadius(20)
        .ignoresSafeArea(.all)
    }
}

// Перечисление источников изображения
enum ImageSource {
    case camera
    case gallery
    case files
}
