import SwiftUI

extension Color {
    init(hex: String) {
        let hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
                              .replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        let alpha = hexSanitized.count == 8 ? Double((rgb >> 24) & 0xFF) / 255.0 : 1.0
        
        self.init(red: red, green: green, blue: blue, opacity: alpha)
    }

    static let appBackground = Color(hex: "#FFFFFF")
    static let appSecondaryBackground = Color(hex: "#F2F6F9")

    static let appPrimaryText = Color(hex: "#1C1C1E")
    static let appSecondaryText = Color(hex: "#6E6E73")

    static let appAccent = Color(hex: "#1A73E8")

    static let appSuccess = Color(hex: "#34C759")
    static let appWarning = Color(hex: "#FFCC00")
    static let appDanger = Color(hex: "#FF3B30")

    static let appSkinTone = Color(hex: "#FFD3B5")
    static let appDivider = Color(hex: "#D1D1D6")
}
