import SwiftUI

struct ImageEditingView: View {
    @State var image: UIImage
    @State private var cropRect: CGRect = .zero
    @State private var croppedImage: UIImage?
    var onCropFinished: (UIImage?) -> Void

    @Environment(\.dismiss) private var dismiss
    
    private let containerSize = CGSize(width: 300, height: 300)

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                createTitleText()
                createImageContainer()
                createButtonsStack()
            }
            .frame(maxHeight: .infinity)
        }
        .background(Color.appBackground)
    }

    private func cropImage() {
        croppedImage = image.cropped(to: cropRect)
        onCropFinished(croppedImage)
        dismiss()
    }
    
    @ViewBuilder
    private func createTitleText() -> some View {
        VStack {
            Text("Выделите участок кожи")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            Text("Поместите нужную область внутрь квадрата. Вы можете перемещать рамку и изменять масштаб изображения для точного выбора.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding(.top)
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    @ViewBuilder
    private func createButtonsStack() -> some View {
        VStack {
            Button(action: {
                cropImage()
            }) {
                Text("Готово")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
            }
            Button(action: {
                dismiss()
            }) {
                Text("Отмена")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.appSecondaryText)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
            }
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding(.bottom)
    }
    
    @ViewBuilder
    private func createImageContainer() -> some View {
        ImageCropper(
            image: $image,
            cropRect: $cropRect,
            containerSize: containerSize
        )
        .frame(width: containerSize.width, height: containerSize.height)
    }
}

#Preview {
    ImageEditingView(image: UIImage(named: "randomImg")!, onCropFinished: { _ in })
}
