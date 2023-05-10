//  DateUtils.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 19/01/2021.

import Foundation

public final class AttDateUtils {
    
    static private let dateFormatter: DateFormatter = createFormatter()
    
    static func createFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }
    
    static func convertISO8601(string: String) -> Date? {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return dateFormatter.date(from: string)
    }
    static func convertISO(string: String) -> Date? {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS z"
        return dateFormatter.date(from: string)
    }
    static func convertToShortDate(string: String) -> Date? {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: string)
    }
    
    static func daysBetween(date1: Date, date2:  Date) -> Int? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day
    }
    
   public static func formatDate(_ date: Date) -> String {
       dateFormatter.dateFormat = "MM/dd/yyyy"
       return dateFormatter.string(from: date)
    }
    
    static func prettyFormatDate(_ date: Date) -> String {
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
    
    static func formatISO8601(_ date: Date) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return dateFormatter.string(from: date)
    }
   
    static func convertMilisecondsToDays(startTime: Int, endTime: Int) -> Int {
        var result = endTime - startTime
        result = ((result / 1000) / 3600 ) / 24
        return result
    }
    

    
    public static func formatCachedTimeString(timeAgo: String, compareTo now: Date = Date()) -> String {
        let df = DateFormatter()
        let dateFormat = "yyyy-MM-dd HH:mm:ss.SSS z"
        df.dateFormat = dateFormat
        guard let dateWithTime = df.date(from: timeAgo) else { return ""}

        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateWithTime, to: now)
        let minute = interval.minute
        let hour = interval.hour
        guard let minute = minute else { return ""}
        guard let hour = hour else { return ""}
        
        if minute < 1 && hour == 0 {
            return "cache_moments_ago".localized()
        }else if minute < 60 && hour == 0 {
            return "\(minute)" + " " + "cache_minutes_ago".localized()
        }else if minute >= 60 && hour < 2 {
            return "cache_an_hour_ago".localized()
        }else if hour < 24 {
            return "\(hour)" + " " + "cache_hours_ago".localized()
        }else if hour == 24 {
            return "cache_yesterday".localized()
        }else if hour > 24 {
            return ("cache_on".localized() + "\(interval.month!)" + "/" + "\(interval.day!)" + "/" + "\(interval.year!)")
        }else {
            return ""
        }
    }
}

extension Date {
    var millisecondsSince1970:Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
