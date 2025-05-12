import Foundation

struct ProfileStatistics {
    var totalScans: Int
    var safeScans: Int
    var monitorScans: Int
    var dangerousScans: Int

    static var empty: ProfileStatistics {
        ProfileStatistics(totalScans: 0, safeScans: 0, monitorScans: 0, dangerousScans: 0)
    }
}
