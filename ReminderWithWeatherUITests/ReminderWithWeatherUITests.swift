//
//  ReminderWithWeatherUITests.swift
//  ReminderWithWeatherUITests
//
//  Created by Polina Sadouskaya on 27/03/2023.
//

import XCTest

final class ReminderWithWeatherUITests: XCTestCase {
    
    var interruptionMonitor: NSObjectProtocol!
    let alertDescription = "Allow 'ReminderWithWeather' to use your location?"
    
    func dismissKeyboardIfPresent(app: XCUIApplication) {
        if app.keyboards.element(boundBy: 0).exists {
            if UIDevice.current.userInterfaceIdiom == .pad {
                app.keyboards.buttons["Hide keyboard"].tap()
            } else {
                app.toolbars.buttons["Done"].tap()
            }
        }
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    } 
    
    func test01AddNewEventAllType() throws {
        let identifier = Int.random(in: 0 ... 1000)
        let testData = TestData(name: "Test add new item \(identifier)",
                                description: "Description new item \(identifier)",
                                type: "All",
                                date: "18-04-2023")
               
        let app = XCUIApplication()
        app.launch()
        app.images["add"].tap()
        app.textFields["Name"].tap()
        app.textFields["Name"].typeText(testData.name)
        app.textFields["Description"].tap()
        app.textFields["Description"].typeText(testData.description)
        
        app.buttons["Date and Time Picker"].tap()
        //app.buttons["Next Month"].tap()
        app.buttons[testData.dateToChoose!].tap()
        app.buttons["dismiss popup"].tap()
        //app.buttons["Date and Time Picker"].tap()
        
        dismissKeyboardIfPresent(app: app)
        app.buttons["Save"].tap()
        
        XCTAssert(app.staticTexts[testData.name].exists)
    }
    
    func test01AddNewEventInsideType() throws {
        let identifier = Int.random(in: 0 ... 1000)
        let testData = TestData(name: "Test add new item \(identifier)",
                                description: "Description new item \(identifier)",
                                type: "Inside events",
                                date: "18-04-2023")
               
        let app = XCUIApplication()
        app.launch()
        app.images["add"].tap()
        app.textFields["Name"].tap()
        app.textFields["Name"].typeText(testData.name)
        app.textFields["Description"].tap()
        app.textFields["Description"].typeText(testData.description)
        
        app.buttons["Date and Time Picker"].tap()
        //app.buttons["Next Month"].tap()
        app.buttons[testData.dateToChoose!].tap()
        app.buttons["dismiss popup"].tap()
        //app.buttons["Date and Time Picker"].tap()
        
        app.buttons["typeOfEvent"].tap()
        app.buttons[testData.type].tap()
        dismissKeyboardIfPresent(app: app)
        app.buttons["Save"].tap()
        
        XCTAssert(app.staticTexts[testData.name].exists)
    }
    
    func test01AddNewEventOutsideType() throws {
        let identifier = Int.random(in: 0 ... 1000)
        let testData = TestData(name: "Test add new item \(identifier)",
                                description: "Description new item \(identifier)",
                                type: "Outside events",
                                date: "18-04-2023")
               
        let app = XCUIApplication()
        app.launch()
        app.images["add"].tap()
        app.textFields["Name"].tap()
        app.textFields["Name"].typeText(testData.name)
        app.textFields["Description"].tap()
        app.textFields["Description"].typeText(testData.description)
        
        app.buttons["Date and Time Picker"].tap()
        //app.buttons["Next Month"].tap()
        app.buttons[testData.dateToChoose!].tap()
        app.buttons["dismiss popup"].tap()
        //app.buttons["Date and Time Picker"].tap()
        
        app.buttons["typeOfEvent"].tap()
        app.buttons[testData.type].tap()
        dismissKeyboardIfPresent(app: app)
        app.buttons["Save"].tap()
        
        XCTAssert(app.staticTexts[testData.name].exists)
    }
    
    
    func test02OutsideEventsFilter() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        let allEventsCount = app.tables.cells.count
        app.buttons["All"].tap()
        app.buttons["Outside events"].tap()
        
        let cells = app.tables.cells.allElementsBoundByIndex
        let filteredEventsCount = app.tables.cells.count
        XCTAssert(filteredEventsCount <= allEventsCount)
        for c in cells {
            XCTAssert(c.images.matching(identifier: "sun.max.circle").element.exists)
        }
    }
    func test03InsideEventsFilter() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        let allEventsCount = app.tables.cells.count
        app.buttons["All"].tap()
        app.buttons["Inside events"].tap()
        
        let cells = app.tables.cells.allElementsBoundByIndex
        let filteredEventsCount = app.tables.cells.count
        XCTAssert(filteredEventsCount <= allEventsCount)
        for c in cells {
            XCTAssert(c.images.matching(identifier: "house.circle").element.exists)
        }
    }
    
    func test04ListEvents() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        app.tables.cells.firstMatch.waitForExistence(timeout: 10000.0)
        let cell = app.tables.cells.firstMatch
        XCTAssert(cell.images["typeImage"].exists)
        XCTAssert(cell.staticTexts["cellName"].exists)
        XCTAssert(cell.staticTexts["cellDate"].exists)
        XCTAssert(app.tables.cells.count>0)

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func test05UpdateEvent() throws {
        // UI tests must launch the application that they test.
        let identifier = Int.random(in: 0 ... 1000)
        var testData = TestData(name: "Test update item \(identifier)",
                                description: "Description update item \(identifier)",
                                type: "Inside events",
                                date: "19-04-2023")
       
               
        let app = XCUIApplication()
        app.launch()
        let table = app.tables.firstMatch
        let cell = table.cells.firstMatch
        
        let label = cell.staticTexts["cellName"].label
        let data = cell.staticTexts["cellDate"].label
        print("Label is \(label) and date is \(data)")
        
        cell.tap()
        app.buttons["Edit"].tap()
        
        self.interruptionMonitor = addUIInterruptionMonitor(withDescription: self.alertDescription) { (alert) -> Bool in
                    // check for a specific button
                    if alert.buttons["Allow While Using App"].exists {
                        alert.buttons["Allow While Using App"].tap()
                        return true
                    }
                    return false
                }
        sleep(5)
        
        app.textFields["Name"].clearAndEnterText(text: testData.name)
        app.textFields["Description"].clearAndEnterText(text: testData.description)
        
        app.buttons["Date and Time Picker"].tap()
        //app.buttons["Next Month"].tap()
        app.buttons[testData.dateToChoose!].tap()
        app.buttons["dismiss popup"].tap()
        //app.buttons["Date and Time Picker"].tap()
        
        let typeBtnLabel = app.buttons["typeOfEvent"].label
        app.buttons["typeOfEvent"].tap()
        //select different type
        testData.type = EventTypes.getNotEqualTo(element: typeBtnLabel) ?? "Inside events"
        app.buttons[testData.type].tap()
        dismissKeyboardIfPresent(app: app)
        app.buttons["Save"].tap()
        
        XCTAssertFalse(app.staticTexts[label].exists)
        app.staticTexts[testData.name].tap()
                
        XCTAssert(app.staticTexts[testData.name].exists)
        XCTAssert(app.staticTexts[testData.description].exists)
        XCTAssert(app.staticTexts[testData.type].exists)
        XCTAssert(app.staticTexts[testData.date].exists)
              
    }

    func test06DeleteEvent() throws {
        // UI tests must launch the application that they test.
        
        let app = XCUIApplication()
        app.launch()
        let table = app.tables.firstMatch
        let cell = table.cells.firstMatch
        
        let label = cell.staticTexts["cellName"].label
        let data = cell.staticTexts["cellDate"].label
        print("Label is \(label) and date is \(data)")
        cell.tap()
        app.buttons["Delete"].tap()
        XCTAssertFalse(app.staticTexts[label].exists)
    }


    func test07CheckWeatherSetForEvent() throws {
        let app = XCUIApplication()
        app.launch()
        let table = app.tables.firstMatch
        let cell = table.cells.firstMatch
        
        let label = cell.staticTexts["cellName"].label
        let data = cell.staticTexts["cellDate"].label
        print("Label is \(label) and date is \(data)")
        
        cell.tap()
        
        let expectation = expectation(
            for: NSPredicate( format: "label != %@", "Label"),
            evaluatedWith: app.staticTexts["weatherLabel"],
            handler: .none
        )

        let result = XCTWaiter.wait(for: [expectation], timeout: 5.0)
        print(app.staticTexts["weatherLabel"].label)

        XCTAssertEqual(result, .completed)
        
    }
    
}
