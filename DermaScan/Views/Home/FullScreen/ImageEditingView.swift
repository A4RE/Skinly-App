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
                
                ImageCropper(
                    image: $image,
                    cropRect: $cropRect,
                    containerSize: containerSize
                )
                .frame(width: containerSize.width, height: containerSize.height)
                .border(Color.gray, width: 1)

                VStack {
                    Spacer()

                    Button(action: {
                        cropImage()
                    }) {
                        Text("Готово")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Отмена")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                }
            }
        }
        .background(Color.appBackground)
    }

    private func cropImage() {
        croppedImage = image.cropped(to: cropRect)
        onCropFinished(croppedImage)
        dismiss()
    }
}

#Preview {
    ImageEditingView(image: UIImage(named: "randomImg")!, onCropFinished: { _ in })
}
