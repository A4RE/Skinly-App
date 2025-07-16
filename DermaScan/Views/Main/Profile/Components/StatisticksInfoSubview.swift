import SwiftUI

struct StatisticksInfoSubview: View {
    var name: LocalizedStringKey
    var image: String
    var value: Int
    var percentage: Int?
    var body: some View {
        HStack {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .foregroundColor(color)
                .frame(height: 20)
            (
                Text(name) + Text(": \(value)") +
                Text(percentage != nil ? " (\(percentage!)%)" : "")
            )
            .font(.subheadline)
            .foregroundColor(color)
        }
    }
    
    private var color: Color {
        switch name {
        case "safety_scans": Color.green
        case "looking_scans": Color.yellow
        case "warning_scans": Color.red
        default: Color.appPrimaryText
        }
    }
}
