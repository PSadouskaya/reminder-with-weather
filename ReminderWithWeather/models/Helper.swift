//
//  Helper.swift
//  ReminderWithWeather
//
//  Created by Polina Sadouskaya on 03/04/2023.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

struct Helper {
    static func getDateFromTimestamp(timestamp: Timestamp) -> NSDate {
        let int64Value: Int64 = timestamp.seconds
        let doubleValue = NSNumber(value: int64Value).doubleValue
        let date = NSDate(timeIntervalSince1970: doubleValue)
        return date
    }
    
    static func getDateFromInt(int: Int) -> NSDate {
        let date = NSDate(timeIntervalSince1970: Double(int))
        return date
    }
    
    static func getDateStringWithFormat(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        var res = formatter.string(from: date)
        return res
    }
    
    static func getCelsiusFromFarenheit(tempr: Double) -> Double {
        var result = (tempr - 32) * 0.5556
        return result.rounded()
    }
}
