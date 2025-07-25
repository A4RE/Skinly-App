import SwiftUI

struct HistoryItemView: View {
    let scanCase: ScanCase

    var body: some View {
        HStack(spacing: 16) {
            if let imageData = scanCase.firstImageData,
               let imageDataDecoded = Data(base64Encoded: imageData),
               let uiImage = UIImage(data: imageDataDecoded) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.appSecondaryBackground)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedStringKey(scanCase.latestDiagnosis))
                    .font(.headline)
                    .foregroundColor(Color.appPrimaryText)
                Text(scanCase.latestDateFormatted)
                    .font(.subheadline)
                    .foregroundColor(Color.appSecondaryText)
                Text(scanCase.latestDiagonsis)
                    .font(.headline)
                    .foregroundStyle(scanCase.scans.last?.diagnosis.riskLevel.color ?? .gray)
            }
            Spacer()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(Color.appBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 3)

    }
}
