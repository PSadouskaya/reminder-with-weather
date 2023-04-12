//
//  Helper.swift
//  ReminderWithWeatherUITests
//
//  Created by Polina Sadouskaya on 04/04/2023.
//

import Foundation
import XCTest

struct Helper {
    
}

extension XCUIElement {
    func clearAndEnterText(text: String) {
            guard let stringValue = self.value as? String else {
                XCTFail("Tried to clear and enter text into a non string value")
                return
            }

            self.tap()
            let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)

            self.typeText(deleteString)
            self.typeText(text)
        }
}
