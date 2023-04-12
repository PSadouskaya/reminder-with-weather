//
//  WeatherDataModel.swift
//  ReminderWithWeather
//
//  Created by Polina Sadouskaya on 03/04/2023.
//

import Foundation

struct WeatherDataModel : Codable {
    let days : [Days]
    
}

struct Days: Codable {
    let datetime: String
    let temp: Double
}

