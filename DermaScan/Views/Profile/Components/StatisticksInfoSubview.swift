import SwiftUI

struct StatisticksInfoSubview: View {
    var name: String
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
            Text("\(name): \(value) \(percentage != nil ? "(\(percentage!)%)" : "")")
                .font(.subheadline)
                .foregroundColor(color)
        }
    }
    
    private var color: Color {
        switch name {
        case "Безопасных": Color.green
        case "Под наблюдением": Color.yellow
        case "Опасных": Color.red
        default: Color.appPrimaryText
        }
    }
}
