import Foundation

struct AgeComponents {
    let years: Int
    let months: Int
    let weeks: Int
    let days: Int
    let hours: Int
    let minutes: Int
    let seconds: Int
    
    var formattedString: String {
        return "\(years).\(months).\(weeks).\(days).\(hours).\(minutes).\(seconds)"
    }
}

class AgeCalculator {
    static func calculateAge(from birthDate: Date, to currentDate: Date = Date()) -> AgeComponents {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: birthDate,
            to: currentDate
        )
        
        // Note: 'weekOfMonth' or 'weekOfYear' isn't directly given by dateComponents between two dates in a simple way 
        // that sums up to exact duration components as requested (Y.M.W.D...).
        // Standard dateComponents returns total years, remaining months, remaining days.
        // We need to extract weeks from the remaining days.
        
        let years = components.year ?? 0
        let months = components.month ?? 0
        let totalDaysRaw = components.day ?? 0
        
        let weeks = totalDaysRaw / 7
        let days = totalDaysRaw % 7
        
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        let seconds = components.second ?? 0
        
        return AgeComponents(
            years: years,
            months: months,
            weeks: weeks,
            days: days,
            hours: hours,
            minutes: minutes,
            seconds: seconds
        )
    }
    
    static func calculateDecimalAge(from birthDate: Date, to currentDate: Date = Date()) -> Double {
        let ageInSeconds = currentDate.timeIntervalSince(birthDate)
        // Average seconds in a Gregorian year (365.2425 days)
        let secondsInYear = 31556952.0 
        return ageInSeconds / secondsInYear
    }
    
    struct DetailedAge {
        let year: Int
        let month: Int
        let week: Int
        let day: Int
        let hour: Int
        let minute: Int
        let second: Int
    }
    
    static func calculateDetailedAge(from birthDate: Date, to currentDate: Date = Date()) -> DetailedAge {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: birthDate, to: currentDate)
        
        let year = components.year ?? 0
        let month = components.month ?? 0
        let fullDays = components.day ?? 0
        
        // Split remaining days into Weeks and Days
        let week = fullDays / 7
        let day = fullDays % 7
        
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let second = components.second ?? 0
        
        return DetailedAge(year: year, month: month, week: week, day: day, hour: hour, minute: minute, second: second)
    }
}
