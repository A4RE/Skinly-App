import SwiftUI
import UIKit

struct ImageCropper: UIViewRepresentable {
    @Binding var image: UIImage
    @Binding var cropRect: CGRect
    let containerSize: CGSize
    
    private let cropAreaSize: CGSize = CGSize(width: 100, height: 100)
    
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .systemGray5
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(origin: .zero, size: containerSize)
        containerView.addSubview(imageView)
        
        let imageViewSize = calculateAspectFitSize(
            imageSize: image.size,
            boundingSize: containerSize
        )
        
        let cropView = UIView()
        cropView.frame = CGRect(
            x: (containerSize.width - cropAreaSize.width) / 2,
            y: (containerSize.height - cropAreaSize.height) / 2,
            width: cropAreaSize.width,
            height: cropAreaSize.height
        )
        
        cropView.layer.borderColor = UIColor.white.cgColor
        cropView.layer.borderWidth = 2.0
        cropView.layer.cornerRadius = 8.0
        cropView.backgroundColor = UIColor.clear.withAlphaComponent(0.3)
        containerView.addSubview(cropView)
        
        let dragGesture = UIPanGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleDrag))
        cropView.addGestureRecognizer(dragGesture)
        
        context.coordinator.imageViewSize = imageViewSize
        context.coordinator.containerSize = containerSize
        updateCropRect(cropView.frame, coordinator: context.coordinator)
        
        return containerView
    }
    
    private func calculateAspectFitSize(imageSize: CGSize, boundingSize: CGSize) -> CGSize {
        let widthRatio = boundingSize.width / imageSize.width
        let heightRatio = boundingSize.height / imageSize.height
        let scale = min(widthRatio, heightRatio)
        
        return CGSize(
            width: imageSize.width * scale,
            height: imageSize.height * scale
        )
    }
    
    private func updateCropRect(_ rect: CGRect, coordinator: Coordinator) {
        let scaleX = image.size.width / coordinator.imageViewSize.width
        let scaleY = image.size.height / coordinator.imageViewSize.height
        
        let offsetX = (coordinator.containerSize.width - coordinator.imageViewSize.width) / 2
        let offsetY = (coordinator.containerSize.height - coordinator.imageViewSize.height) / 2
        
        let convertedRect = CGRect(
            x: (rect.origin.x - offsetX) * scaleX,
            y: (rect.origin.y - offsetY) * scaleY,
            width: rect.width * scaleX,
            height: rect.height * scaleY
        )
        
        DispatchQueue.main.async {
            self.cropRect = convertedRect
        }
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let imageView = uiView.subviews.first as? UIImageView {
            imageView.image = image
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: ImageCropper
        var imageViewSize: CGSize = .zero
        var containerSize: CGSize = .zero
        
        init(_ parent: ImageCropper) {
            self.parent = parent
        }
        
        @objc func handleDrag(gesture: UIPanGestureRecognizer) {
            guard let cropView = gesture.view else { return }
            
            let translation = gesture.translation(in: cropView.superview)
            
            var newCenter = CGPoint(
                x: cropView.center.x + translation.x,
                y: cropView.center.y + translation.y
            )
            
            let minX = (containerSize.width - imageViewSize.width) / 2 + cropView.bounds.width/2
            let maxX = containerSize.width - (containerSize.width - imageViewSize.width)/2 - cropView.bounds.width/2
            let minY = (containerSize.height - imageViewSize.height)/2 + cropView.bounds.height/2
            let maxY = containerSize.height - (containerSize.height - imageViewSize.height)/2 - cropView.bounds.height/2
            
            newCenter.x = max(minX, min(newCenter.x, maxX))
            newCenter.y = max(minY, min(newCenter.y, maxY))
            
            cropView.center = newCenter
            parent.updateCropRect(cropView.frame, coordinator: self)
            
            gesture.setTranslation(.zero, in: cropView.superview)
        }
    }
}
