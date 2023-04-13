//
//  TestData.swift
//  ReminderWithWeatherUITests
//
//  Created by Polina Sadouskaya on 04/04/2023.
//

import Foundation

struct TestData {
    var name: String
    var description: String
    var type: String
    var date: String
    var dateToChoose: String?
    
    init(name: String, description: String, type: String, date: String) {
        self.name = name
        self.description = description
        self.type = type
        self.date = date
        self.dateToChoose = setDateToChoose(date: date)
    }
        
    func setDateToChoose(date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yy"
        let newDate = formatter.date(from: date)
        
        formatter.dateFormat = ("EEEE, MMMM d")
        formatter.locale = Locale(identifier: "EN-us")
        //formatter.dateFormat = ("EEEE, d MMMM")
        //formatter.locale = Locale(identifier: "RU-ru")
        let result = formatter.string(from: newDate!)
        return result
    }
    
    
}

struct EventTypes {
   static let types = ["All", "Inside events", "Outside events"]
    
    static func getRandomType() -> String {
        return types.randomElement()!
    }
    
    static func getNotEqualTo(element: String) -> String? {
        for t in types {
            if element != t {
                return t
            }
        }
        return nil
    }
}
