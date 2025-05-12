import SwiftUI

struct ScanItemView: View {
    let scan: Scan

    var body: some View {
        HStack(spacing: 16) {
            if let imageDataDecoded = Data(base64Encoded: scan.imageData),
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

            Spacer()
                .frame(width: 3)
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(scan.diagnosis.label)
                        .font(.headline)
                        .foregroundColor(.appPrimaryText)
                    Text(scan.date.formatted(.dateTime.day().month().year()))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Text(scan.diagnosis.riskLevel.rawValue)
                    .font(.headline)
                    .foregroundColor(scan.diagnosis.riskLevel.color)
            }
            .padding(.vertical, 5)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.appBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 3)

    }
}
