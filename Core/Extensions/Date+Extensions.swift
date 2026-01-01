//
//  Date+Extensions.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import Foundation

// MARK: - Date Extensions

extension Date {
    
    // MARK: - Formatting
    
    /// Common date format styles
    enum DateStyle {
        case short          // "1/1/26"
        case medium         // "Jan 1, 2026"
        case long           // "January 1, 2026"
        case full           // "Wednesday, January 1, 2026"
        case time           // "11:30 PM"
        case dateTime       // "Jan 1, 2026 at 11:30 PM"
        case iso8601        // "2026-01-01T23:30:00Z"
        case custom(String) // Custom format string
    }
    
    /// Format date with predefined style
    /// - Parameter style: DateStyle to use
    /// - Returns: Formatted date string
    ///
    /// Example:
    /// ```swift
    /// Date().formatted(style: .medium) // "Jan 1, 2026"
    /// Date().formatted(style: .time) // "11:30 PM"
    /// Date().formatted(style: .custom("yyyy-MM-dd")) // "2026-01-01"
    /// ```
    func formatted(style: DateStyle) -> String {
        let formatter = DateFormatter()
        
        switch style {
        case .short:
            formatter.dateStyle = .short
            formatter.timeStyle = .none
        case .medium:
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
        case .long:
            formatter.dateStyle = .long
            formatter.timeStyle = .none
        case .full:
            formatter.dateStyle = .full
            formatter.timeStyle = .none
        case .time:
            formatter.dateStyle = .none
            formatter.timeStyle = .short
        case .dateTime:
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
        case .iso8601:
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        case .custom(let format):
            formatter.dateFormat = format
        }
        
        return formatter.string(from: self)
    }
    
    // MARK: - Relative Time
    
    /// Get relative time string (e.g., "2 hours ago", "just now")
    /// - Returns: Human-readable relative time string
    ///
    /// Example:
    /// ```swift
    /// Date().timeAgo() // "just now"
    /// Date().addingTimeInterval(-3600).timeAgo() // "1 hour ago"
    /// ```
    func timeAgo() -> String {
        let now = Date()
        let components = Calendar.current.dateComponents(
            [.year, .month, .weekOfYear, .day, .hour, .minute, .second],
            from: self,
            to: now
        )
        
        if let years = components.year, years > 0 {
            return years == 1 ? "1 year ago" : "\(years) years ago"
        }
        
        if let months = components.month, months > 0 {
            return months == 1 ? "1 month ago" : "\(months) months ago"
        }
        
        if let weeks = components.weekOfYear, weeks > 0 {
            return weeks == 1 ? "1 week ago" : "\(weeks) weeks ago"
        }
        
        if let days = components.day, days > 0 {
            return days == 1 ? "1 day ago" : "\(days) days ago"
        }
        
        if let hours = components.hour, hours > 0 {
            return hours == 1 ? "1 hour ago" : "\(hours) hours ago"
        }
        
        if let minutes = components.minute, minutes > 0 {
            return minutes == 1 ? "1 minute ago" : "\(minutes) minutes ago"
        }
        
        if let seconds = components.second, seconds > 30 {
            return "\(seconds) seconds ago"
        }
        
        return "just now"
    }
    
    // MARK: - Date Components
    
    /// Start of day (00:00:00)
    /// - Returns: Date at start of day
    ///
    /// Example:
    /// ```swift
    /// Date().startOfDay // Today at 00:00:00
    /// ```
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    /// End of day (23:59:59)
    /// - Returns: Date at end of day
    ///
    /// Example:
    /// ```swift
    /// Date().endOfDay // Today at 23:59:59
    /// ```
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay) ?? self
    }
    
    /// Start of week
    /// - Returns: Date at start of current week
    var startOfWeek: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components) ?? self
    }
    
    /// End of week
    /// - Returns: Date at end of current week
    var endOfWeek: Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.weekOfYear = 1
        components.second = -1
        return calendar.date(byAdding: components, to: startOfWeek) ?? self
    }
    
    /// Start of month
    /// - Returns: Date at start of current month
    var startOfMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components) ?? self
    }
    
    /// End of month
    /// - Returns: Date at end of current month
    var endOfMonth: Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return calendar.date(byAdding: components, to: startOfMonth) ?? self
    }
    
    // MARK: - Date Manipulation
    
    /// Add days to date
    /// - Parameter days: Number of days to add (can be negative)
    /// - Returns: New date with days added
    ///
    /// Example:
    /// ```swift
    /// Date().addDays(7) // One week from now
    /// Date().addDays(-1) // Yesterday
    /// ```
    func addDays(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    /// Add months to date
    /// - Parameter months: Number of months to add (can be negative)
    /// - Returns: New date with months added
    ///
    /// Example:
    /// ```swift
    /// Date().addMonths(3) // Three months from now
    /// ```
    func addMonths(_ months: Int) -> Date {
        Calendar.current.date(byAdding: .month, value: months, to: self) ?? self
    }
    
    /// Add years to date
    /// - Parameter years: Number of years to add (can be negative)
    /// - Returns: New date with years added
    ///
    /// Example:
    /// ```swift
    /// Date().addYears(1) // One year from now
    /// ```
    func addYears(_ years: Int) -> Date {
        Calendar.current.date(byAdding: .year, value: years, to: self) ?? self
    }
    
    /// Add hours to date
    /// - Parameter hours: Number of hours to add (can be negative)
    /// - Returns: New date with hours added
    ///
    /// Example:
    /// ```swift
    /// Date().addHours(2) // Two hours from now
    /// ```
    func addHours(_ hours: Int) -> Date {
        Calendar.current.date(byAdding: .hour, value: hours, to: self) ?? self
    }
    
    /// Add minutes to date
    /// - Parameter minutes: Number of minutes to add (can be negative)
    /// - Returns: New date with minutes added
    func addMinutes(_ minutes: Int) -> Date {
        Calendar.current.date(byAdding: .minute, value: minutes, to: self) ?? self
    }
    
    // MARK: - Date Comparison
    
    /// Check if date is today
    /// - Returns: true if date is today
    ///
    /// Example:
    /// ```swift
    /// Date().isToday // true
    /// ```
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    /// Check if date is yesterday
    /// - Returns: true if date is yesterday
    ///
    /// Example:
    /// ```swift
    /// Date().addDays(-1).isYesterday // true
    /// ```
    var isYesterday: Bool {
        Calendar.current.isDateInYesterday(self)
    }
    
    /// Check if date is tomorrow
    /// - Returns: true if date is tomorrow
    ///
    /// Example:
    /// ```swift
    /// Date().addDays(1).isTomorrow // true
    /// ```
    var isTomorrow: Bool {
        Calendar.current.isDateInTomorrow(self)
    }
    
    /// Check if date is in the past
    /// - Returns: true if date is before now
    var isPast: Bool {
        self < Date()
    }
    
    /// Check if date is in the future
    /// - Returns: true if date is after now
    var isFuture: Bool {
        self > Date()
    }
    
    /// Check if date is in current week
    /// - Returns: true if date is in current week
    var isInCurrentWeek: Bool {
        Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }
    
    /// Check if date is in current month
    /// - Returns: true if date is in current month
    var isInCurrentMonth: Bool {
        Calendar.current.isDate(self, equalTo: Date(), toGranularity: .month)
    }
    
    /// Check if date is in current year
    /// - Returns: true if date is in current year
    var isInCurrentYear: Bool {
        Calendar.current.isDate(self, equalTo: Date(), toGranularity: .year)
    }
    
    /// Check if date is weekend
    /// - Returns: true if date is Saturday or Sunday
    var isWeekend: Bool {
        Calendar.current.isDateInWeekend(self)
    }
    
    /// Check if date is weekday
    /// - Returns: true if date is Monday-Friday
    var isWeekday: Bool {
        !isWeekend
    }
    
    /// Check if two dates are on the same day
    /// - Parameter date: Date to compare with
    /// - Returns: true if both dates are on the same day
    ///
    /// Example:
    /// ```swift
    /// date1.isSameDay(as: date2)
    /// ```
    func isSameDay(as date: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: date)
    }
    
    // MARK: - Date Components Extraction
    
    /// Year component
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
    
    /// Month component (1-12)
    var month: Int {
        Calendar.current.component(.month, from: self)
    }
    
    /// Day component (1-31)
    var day: Int {
        Calendar.current.component(.day, from: self)
    }
    
    /// Hour component (0-23)
    var hour: Int {
        Calendar.current.component(.hour, from: self)
    }
    
    /// Minute component (0-59)
    var minute: Int {
        Calendar.current.component(.minute, from: self)
    }
    
    /// Second component (0-59)
    var second: Int {
        Calendar.current.component(.second, from: self)
    }
    
    /// Weekday component (1 = Sunday, 7 = Saturday)
    var weekday: Int {
        Calendar.current.component(.weekday, from: self)
    }
    
    /// Weekday name (e.g., "Monday")
    var weekdayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }
    
    /// Month name (e.g., "January")
    var monthName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: self)
    }
    
    // MARK: - Time Intervals
    
    /// Days between this date and another date
    /// - Parameter date: Date to compare with
    /// - Returns: Number of days between dates
    ///
    /// Example:
    /// ```swift
    /// let days = date1.days(from: date2)
    /// ```
    func days(from date: Date) -> Int {
        Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    /// Hours between this date and another date
    /// - Parameter date: Date to compare with
    /// - Returns: Number of hours between dates
    func hours(from date: Date) -> Int {
        Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
    /// Minutes between this date and another date
    /// - Parameter date: Date to compare with
    /// - Returns: Number of minutes between dates
    func minutes(from date: Date) -> Int {
        Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    // MARK: - Age Calculation
    
    /// Calculate age from date (useful for birthdate)
    /// - Returns: Age in years
    ///
    /// Example:
    /// ```swift
    /// let birthdate = Date() // Some past date
    /// let age = birthdate.age // Returns age in years
    /// ```
    var age: Int {
        Calendar.current.dateComponents([.year], from: self, to: Date()).year ?? 0
    }
}
