import UIKit

extension UIImage {
    func resizedToSafeSize(maxSize: CGFloat = 1024) -> UIImage {
        let originalSize = self.size
        let aspectRatio = originalSize.width / originalSize.height

        var targetSize: CGSize

        if aspectRatio > 1 {
            // Горизонтальное фото
            targetSize = CGSize(width: maxSize, height: maxSize / aspectRatio)
        } else {
            // Вертикальное фото
            targetSize = CGSize(width: maxSize * aspectRatio, height: maxSize)
        }

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    func crop(to rect: CGRect) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }

        let scaledRect = CGRect(
            x: rect.origin.x,
            y: rect.origin.y,
            width: rect.size.width,
            height: rect.size.height
        )

        guard let croppedCGImage = cgImage.cropping(to: scaledRect) else { return nil }

        return UIImage(cgImage: croppedCGImage, scale: self.scale, orientation: self.imageOrientation)
    }
}
