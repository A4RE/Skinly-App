import SwiftUI

struct StatisticsView: View {
    let statistics: ProfileStatistics

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                StatisticksInfoSubview(
                    name: "Всего сканирований",
                    image: "magnifyingglass",
                    value: statistics.totalScans
                )
                StatisticksInfoSubview(
                    name: "Безопасных",
                    image: "checkmark.seal.fill",
                    value: statistics.safeScans,
                    percentage: percentage(statistics.safeScans)
                )
                StatisticksInfoSubview(
                    name: "Опасных",
                    image: "xmark.seal.fill",
                    value: statistics.dangerousScans,
                    percentage: percentage(statistics.dangerousScans)
                )
            }
            .font(.subheadline)
            .foregroundColor(.appPrimaryText)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.appSecondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func percentage(_ value: Int) -> Int {
        guard statistics.totalScans > 0 else { return 0 }
        return Int(Double(value) / Double(statistics.totalScans) * 100)
    }
}

#Preview {
    StatisticsView(statistics: ProfileStatistics(totalScans: 100, safeScans: 50, monitorScans: 25, dangerousScans: 25))
}
