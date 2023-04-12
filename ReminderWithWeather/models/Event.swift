//
//  Event.swift
//  ReminderWithWeather
//
//  Created by Polina Sadouskaya on 28/03/2023.
//

import Foundation
import UIKit

struct Event {
    var name: String
    var description: String
    var place: String
    var dateTime: Date
    var weatherColor = UIColor(red: 0.246, green: 0.241, blue: 0.233, alpha: 1)
}
