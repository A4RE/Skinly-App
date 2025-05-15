import SwiftUI
import CropViewController

struct CropViewControllerWrapper: UIViewControllerRepresentable {
    var image: UIImage
    var onCropped: (UIImage?) -> Void
    @Environment(\.dismiss) private var dismiss

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> CropViewController {
        let cropController = CropViewController(croppingStyle: .default, image: image)
        cropController.delegate = context.coordinator
        return cropController
    }

    func updateUIViewController(_ uiViewController: CropViewController, context: Context) {}

    class Coordinator: NSObject, CropViewControllerDelegate {
        let parent: CropViewControllerWrapper

        init(_ parent: CropViewControllerWrapper) {
            self.parent = parent
        }

        func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
            parent.onCropped(image)
            cropViewController.dismiss(animated: true)
        }

        func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
            parent.onCropped(nil)
            cropViewController.dismiss(animated: true)
        }
    }
}
