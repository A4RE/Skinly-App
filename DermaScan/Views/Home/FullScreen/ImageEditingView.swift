import SwiftUI

struct ImageEditingView: View {
    let image: UIImage
    var onCropFinished: (UIImage?) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var dragOffset: CGSize = .zero
    @State private var currentOffset: CGSize = .zero
    @State private var scale: CGFloat = 1.0

    private let initialCropSize: CGFloat = 150

    var body: some View {
        GeometryReader { geometry in
            ZStack {

                Image(uiImage: image)
                    .resizable()
                    .frame(width: geometry.size.height * 0.48, height: geometry.size.height * 0.48)
                    .clipped()

                Rectangle()
                    .stroke(Color.blue, lineWidth: 3)
                    .frame(width: initialCropSize * scale, height: initialCropSize * scale)
                    .offset(dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                self.dragOffset = CGSize(
                                    width: currentOffset.width + value.translation.width,
                                    height: currentOffset.height + value.translation.height
                                )
                            }
                            .onEnded { _ in
                                self.currentOffset = self.dragOffset
                            }
                    )
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                self.scale = max(0.5, min(value, 3.0))
                            }
                    )

                VStack {
                    Spacer()

                    Button(action: {
                        cropImage(in: geometry)
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

    private func cropImage(in geometry: GeometryProxy) {
        let imageSize = image.size
        let frameSize = geometry.size

        let displayedImageHeight = frameSize.width * (imageSize.height / imageSize.width)
        let imageYOffset = (frameSize.height - displayedImageHeight) / 2

        let visibleCropWidth = initialCropSize * scale
        let visibleCropHeight = initialCropSize * scale

        let xRatio = imageSize.width / frameSize.width
        let yRatio = imageSize.height / displayedImageHeight

        let cropX = (frameSize.width / 2 + dragOffset.width - visibleCropWidth / 2) * xRatio
        let cropY = ((frameSize.height - displayedImageHeight) / 2 + (displayedImageHeight / 2) + dragOffset.height - visibleCropHeight / 2) * yRatio

        let cropWidth = visibleCropWidth * xRatio
        let cropHeight = visibleCropHeight * yRatio

        let croppingRect = CGRect(x: cropX, y: cropY, width: cropWidth, height: cropHeight)

        let croppedImage = image.crop(to: croppingRect)
        onCropFinished(croppedImage)
        dismiss()
    }
}

#Preview {
    ImageEditingView(image: UIImage(named: "randomImg")!, onCropFinished: { _ in })
}
