//
//  DateExtensions.swift
//  FetchRewardsTakeHome
//
//  Created by John Demirci on 7/28/21.
//

import UIKit

extension Date {
    var imperialTime: String {
        guard let hr = Int(hour) else { return "" }
        
        var min: String
        if minute == "0" { min = "00"} else { min = minute }
        
        guard hr >= 12
        else { return "\(hr):\(min) AM" }
        
        return "\(hr - 12):\(min) PM"
    }
    
    var hour: String {
        let calendar = Calendar.current
        let components = calendar.dateComponents(
            [
                .hour
            ],
            from: self
        )
        guard let _hour = components.hour else { return "" }
        return String(_hour)
    }
    
    var minute: String {
        let calendar = Calendar.current
        let components = calendar.dateComponents(
            [
                .minute
            ],
            from: self
        )
        guard let _minute = components.minute else { return "" }
        return String(_minute)
    }
    
    var second: String {
        let calendar = Calendar.current
        let components = calendar.dateComponents(
            [
                .second
            ],
            from: self
        )
        guard let _second = components.second else { return "" }
        return String(_second)
    }
    
    var dayName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = "cccc"
        return dateFormatter.string(from: self)
    }
    
    var day: String {
        let calendar = Calendar.current
        let components = calendar.dateComponents(
            [
                .day
            ],
            from: self
        )
        guard let _day = components.day else { return "" }
        return String(_day)
    }
    
    var year: String {
        let calendar = Calendar.current
        let components = calendar.dateComponents(
            [
                .year
            ],
            from: self
        )
        guard let _year = components.year else { return "" }
        return String(_year)
    }
    
    var monthName: String {
        let calendar = Calendar.current
        let components = calendar.dateComponents(
            [
                .month
            ],
            from: self
        )
        guard let _month = components.month else { return "" }
        return getMonthName(_month)
    }
    
    static func changeDateByString(_ dateStr: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard
            let _date = dateFormatter.date(from: dateStr)
        else {
            return Date()
        }
        return _date
    }
    
    private func getMonthName(_ month: Int) -> String {
        switch month {
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "Jun"
        case 7:
            return "Jul"
        case 8:
            return "Aug"
        case 9:
            return "Sep"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        case 12:
            return "Dec"
        default: return ""
        }
    }
}
