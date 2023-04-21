//
//  WeatherDataModel.swift
//  ReminderWithWeather
//
//  Created by Polina Sadouskaya on 03/04/2023.
//

import Foundation

struct WeatherDataModel : Codable {
    let days : [Days]
    let timezone : String
    
}

struct Days: Codable {
    let datetime: String
    let temp: Double
    let description : String
    let visibility : Double
}

