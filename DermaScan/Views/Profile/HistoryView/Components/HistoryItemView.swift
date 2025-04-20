import SwiftUI

struct HistoryItemView: View {
    let scanCase: ScanCase

    var body: some View {
        HStack(spacing: 16) {
            if let imageData = scanCase.firstImageData,
               let uiImage = UIImage(named: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipped()
                    .cornerRadius(8)
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
                Text(scanCase.latestDiagnosis ?? "Без диагноза")
                    .font(.headline)
                    .foregroundColor(Color.appPrimaryText)
                Text(scanCase.latestDateFormatted)
                    .font(.subheadline)
                    .foregroundColor(Color.appSecondaryText)
            }
            Spacer()
        }
        .background(Color.appBackground)

    }
}
