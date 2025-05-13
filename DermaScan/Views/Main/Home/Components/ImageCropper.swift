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
        containerView.clipsToBounds = true

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.frame = CGRect(origin: .zero, size: containerSize)
        containerView.addSubview(imageView)
        
        imageView.isUserInteractionEnabled = true
        let imagePan = UIPanGestureRecognizer(
          target: context.coordinator,
          action: #selector(Coordinator.handleImagePan(_:))
        )
        imageView.addGestureRecognizer(imagePan)

        context.coordinator.imageView = imageView

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

        context.coordinator.cropView = cropView

        let imageViewSize = calculateAspectFillSize(
            imageSize: image.size,
            boundingSize: containerSize
        )

        context.coordinator.originalImageViewSize = imageViewSize
        context.coordinator.imageViewSize         = imageViewSize
        context.coordinator.containerSize         = containerSize


        let drag = UIPanGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleDrag)
        )
        cropView.addGestureRecognizer(drag)

        let pinch = UIPinchGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handlePinch)
        )
        containerView.addGestureRecognizer(pinch)

        updateCropRect(cropView.frame, coordinator: context.coordinator)

        return containerView
    }
    
    private func calculateAspectFillSize(imageSize: CGSize, boundingSize: CGSize) -> CGSize {
        let widthRatio = boundingSize.width / imageSize.width
        let heightRatio = boundingSize.height / imageSize.height
        let scale = max(widthRatio, heightRatio) // min
        
        return CGSize(
            width: imageSize.width * scale,
            height: imageSize.height * scale
        )
    }
    
    private func updateCropRect(_ rect: CGRect, coordinator: Coordinator) {

        let scaleX = image.size.width  / coordinator.imageViewSize.width
        let scaleY = image.size.height / coordinator.imageViewSize.height


        let offsetX = (coordinator.containerSize.width  - coordinator.imageViewSize.width)  / 2
                    + coordinator.imageOffset.x
        let offsetY = (coordinator.containerSize.height - coordinator.imageViewSize.height) / 2
                    + coordinator.imageOffset.y

        let convertedRect = CGRect(
            x: (rect.origin.x - offsetX) * scaleX,
            y: (rect.origin.y - offsetY) * scaleY,
            width:  rect.width  * scaleX,
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
        
        weak var imageView: UIImageView?
        weak var cropView: UIView?
        var originalImageViewSize: CGSize = .zero
        
        var currentScale: CGFloat = 1.0
        var initialScale: CGFloat = 1.0
        let minScale: CGFloat = 1.0
        let maxScale: CGFloat = 5.0
        
        var imageOffset: CGPoint = .zero
        
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
        
        @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
            guard let imageView = imageView, let cropView = cropView else { return }

            switch gesture.state {
            case .began:
                initialScale = currentScale

            case .changed:
                let proposed = initialScale * gesture.scale
                let clamped  = min(max(proposed, minScale), maxScale)
                currentScale = clamped

                if clamped == minScale {
                    imageView.transform = .identity
                    imageOffset = .zero

                    self.imageViewSize = self.originalImageViewSize

                    let center = CGPoint(x: containerSize.width/2,
                                         y: containerSize.height/2)
                    imageView.center = center

                    parent.updateCropRect(cropView.frame, coordinator: self)
                    return
                }

                imageView.transform = CGAffineTransform(scaleX: clamped, y: clamped)

                imageViewSize = CGSize(
                    width: originalImageViewSize.width  * clamped,
                    height: originalImageViewSize.height * clamped
                )

                let halfImgW = imageViewSize.width  / 2
                let halfImgH = imageViewSize.height / 2
                let halfConW = containerSize.width  / 2
                let halfConH = containerSize.height / 2

                let maxOffsetX = max(halfImgW - halfConW, 0)
                let maxOffsetY = max(halfImgH - halfConH, 0)

                imageOffset.x = min(max(imageOffset.x, -maxOffsetX), maxOffsetX)
                imageOffset.y = min(max(imageOffset.y, -maxOffsetY), maxOffsetY)

                let containerCenter = CGPoint(x: halfConW, y: halfConH)
                imageView.center = CGPoint(
                    x: containerCenter.x + imageOffset.x,
                    y: containerCenter.y + imageOffset.y
                )

                parent.updateCropRect(cropView.frame, coordinator: self)

            case .ended:
                break
            default:
                break
            }
        }
        
        @objc func handleImagePan(_ gesture: UIPanGestureRecognizer) {
            guard
              let imageView = imageView,
              currentScale > 1
            else {
              gesture.setTranslation(.zero, in: imageView?.superview)
              return
            }

            let translation = gesture.translation(in: imageView.superview)
            let rawOffset = CGPoint(
              x: imageOffset.x + translation.x,
              y: imageOffset.y + translation.y
            )

            let frame = imageView.frame
            let halfImgW = frame.size.width  / 2
            let halfImgH = frame.size.height / 2

            let halfContW = containerSize.width  / 2
            let halfContH = containerSize.height / 2

            let maxOffsetX = max(halfImgW - halfContW, 0)
            let maxOffsetY = max(halfImgH - halfContH, 0)

            let clampedOffset = CGPoint(
              x: min(max(rawOffset.x, -maxOffsetX), maxOffsetX),
              y: min(max(rawOffset.y, -maxOffsetY), maxOffsetY)
            )

            let containerCenter = CGPoint(x: halfContW, y: halfContH)
            imageView.center = CGPoint(
              x: containerCenter.x + clampedOffset.x,
              y: containerCenter.y + clampedOffset.y
            )

            if gesture.state == .changed || gesture.state == .ended {
              imageOffset = clampedOffset
              if let cv = cropView {
                parent.updateCropRect(cv.frame, coordinator: self)
              }
            }

            gesture.setTranslation(.zero, in: imageView.superview)
        }
    }
}
