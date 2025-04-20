import SwiftUI

struct ScanItemView: View {
    let scan: Scan

    var body: some View {
        HStack(spacing: 16) {
            Image(scan.imageData)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipped()
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(scan.diagnosis.label)
                        .font(.headline)
                        .foregroundColor(.appPrimaryText)
                    Text(scan.dateFormatted)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Text(scan.diagnosis.riskLevel.rawValue)
                    .font(.headline)
                    .foregroundColor(scan.diagnosis.riskLevel.color)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.appBackground)

    }
}
