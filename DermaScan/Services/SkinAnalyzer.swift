import Foundation
import CoreML
import Vision
import UIKit

final class SkinAnalyzer {
    
    private let model: VNCoreMLModel

    init?() {
        // Загружаем модель из сгенерированного класса
        guard let coreMLModel = try? SkinClassifier(configuration: MLModelConfiguration()).model,
              let visionModel = try? VNCoreMLModel(for: coreMLModel) else {
            return nil
        }
        self.model = visionModel
    }

    /// Основной метод: принимает UIImage, возвращает диагноз и вероятности
    func analyze(image: UIImage, completion: @escaping (String?, [String: Float]) -> Void) {
        guard let ciImage = CIImage(image: image) else {
            print("❌ Невозможно создать CIImage из UIImage")
            completion(nil, [:])
            return
        }

        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else {
                completion(nil, [:])
                return
            }

            let topResult = results.first
            let all = Dictionary(uniqueKeysWithValues: results.map { ($0.identifier, $0.confidence) })

            completion(topResult?.identifier, all)
        }

        let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .up, options: [:])

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("❌ Ошибка при выполнении модели: \(error.localizedDescription)")
                completion(nil, [:])
            }
        }
    }
}
