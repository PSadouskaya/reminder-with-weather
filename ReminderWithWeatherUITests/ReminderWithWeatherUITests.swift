//
//  ReminderWithWeatherUITests.swift
//  ReminderWithWeatherUITests
//
//  Created by Polina Sadouskaya on 27/03/2023.
//

import XCTest

final class ReminderWithWeatherUITests: XCTestCase {
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    } 
    
    
    func testListEvents() throws {
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
    
    func testOutsideEventsFilter() throws {
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
    func testInsideEventsFilter() throws {
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
    
    func testAddNewEvent() throws {
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
        app.buttons["Save"].tap()
        
        XCTAssert(app.staticTexts[testData.name].exists)
    }
    
    func testUpdateEvent() throws {
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
        app.buttons["Save"].tap()
        
        XCTAssertFalse(app.staticTexts[label].exists)
        app.staticTexts[testData.name].tap()
                
        XCTAssert(app.staticTexts[testData.name].exists)
        XCTAssert(app.staticTexts[testData.description].exists)
        XCTAssert(app.staticTexts[testData.type].exists)
        XCTAssert(app.staticTexts[testData.date].exists)
              
    }

    func testDeleteEvent() throws {
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


    func testCheckWeatherSetForEvent() throws {
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
