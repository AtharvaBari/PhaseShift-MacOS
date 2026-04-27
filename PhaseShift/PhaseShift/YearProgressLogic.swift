import Foundation

struct YearProgressLogic {
    static func currentYearProgress() -> (percentage: Double, dayOfYear: Int, daysInYear: Int) {
        let calendar = Calendar.current
        let now = Date()
        let year = calendar.component(.year, from: now)
        
        guard let startOfYear = calendar.date(from: DateComponents(year: year, month: 1, day: 1)),
              let range = calendar.range(of: .day, in: .year, for: now) else {
            return (0, 0, 365)
        }
        
        // Day of Year (1-365/366)
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: now) ?? 1
        let daysInYear = range.count
        
        // Accurate percentage using time
        let secondsInYear = Double(daysInYear) * 24 * 60 * 60
        let elapsed = now.timeIntervalSince(startOfYear)
        
        let percentage = (elapsed / secondsInYear) * 100
        
        return (percentage, dayOfYear, daysInYear)
    }
}
