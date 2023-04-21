//
//  ReminderWithWeatherTests.swift
//  ReminderWithWeatherTests
//
//  Created by Polina Sadouskaya on 27/03/2023.
//
import FirebaseFirestore
import XCTest
@testable import ReminderWithWeather

final class ReminderWithWeatherTests: XCTestCase {
    let db = Firestore.firestore()
    let wm = WeatherManager()
    let url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline"
    let key = "VUHUAHX9KV62NFUUE56UQEP49"
     

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testAPIAccess() async throws {        
        let lat = 54.31
        let lon = 18.31
        let dateString = Helper.getDateStringWithFormat(date: Date.now, format: "YYYY-MM-dd")
        
        let urlString = "\(url)/\(lat),\(lon)/\(dateString)/\(dateString)?key=\(key)"
        
        // Create a URL
        let urlFull = URL(string: urlString)!
        
        // Use an asynchronous function to perform request
        let dataAndResponse: (data: Data, response: URLResponse) = try await URLSession.shared.data(from: urlFull, delegate: nil)
        
        // Assert
        let httpResponse = try XCTUnwrap(dataAndResponse.response as? HTTPURLResponse, "Expected an HTTPURLResponse.")
        print("Response: \(dataAndResponse.response)")
        XCTAssertEqual(httpResponse.statusCode, 200, "Expected a 200 OK response.")
        
        let httpData = try XCTUnwrap(dataAndResponse.data)
        if let obj = wm.parseJsonToObject(weatherData: httpData){
            XCTAssert(obj.timezone == "Europe/Warsaw", "Timezone is \(obj.timezone)")
            XCTAssert(obj.days.count == 1, "Returned result for \(obj.days.count) day(s), expected 1")
            XCTAssert(obj.days[0].datetime == dateString, "Returned result for \(obj.days[0].datetime) date, expected \(dateString)")
            XCTAssert(obj.days[0].temp.isFinite, "Returned result for tempr \(obj.days[0].temp)")
            XCTAssert(!obj.days[0].description.isEmpty, "Returned result for description \(obj.days[0].description)")
            XCTAssert(obj.days[0].visibility.isFinite, "Returned result visibility \(obj.days[0].visibility)")
        } else {
            XCTFail("Response not parsed to WeatherDataModel object")
        }
        
    }
    
    func testAPIFail() {
        let dateString = Helper.getDateStringWithFormat(date: Date.now, format: "YYYY-MM-dd")
        
        let cases = [
            (url:"\(url)/\(dateString)/\(dateString)?key=\(key)", code: 400,  message: "Invalid location found. Please check your location parameter"),
            (url:"\(url)/1000-04-21/1000-04-21?key=\(key)", code: 400,  message: "Invalid year requested. Years must be between 1950 and 2050"),
            (url:"\(url)/\(dateString)/\(dateString)", code: 401, message: "No API key or session found. Please verify that your API key parameter is correct.")
        ]

        for (url, code, message) in cases {
            XCTContext.runActivity(named: "Send request with url \(url)", block: {activity in
            checkError(url: url, code: code, errorMessage: message)
            })
        }
    }
    
    func checkError(url: String, code: Int, errorMessage: String) {
        
            var respCode = 0
            var respMes = ""
            
            let exp = expectation(description: "Request sent and response returned")
            // Create a URL
            
            if let urlFull = URL(string: url){
                // 2. Create session
                let session = URLSession(configuration: .default)
                // 3. Give the session a task
                
                let task = session.dataTask(with: urlFull) {data, response, error in
                    let httpResponse = response as? HTTPURLResponse
                    respCode = httpResponse!.statusCode
                    XCTAssert(respCode == code, "Expected code \(code), but got \(respCode)")
                    
                    
                    if let safedata = data {
                        let responseMessage = String(data: safedata, encoding: String.Encoding.utf8)
                        respMes = responseMessage!
                        XCTAssert(respMes == errorMessage, "Expected message \(errorMessage), but got \(respMes)")
                       
                    } else {
                        XCTFail("No response message present")
                       
                    }
                    exp.fulfill()
                }
                // 4. Start the task
                task.resume()
            }
            waitForExpectations(timeout: 5)

    }
    
    func testDBAddAccess() async throws {
        //get count
        let countBefore = try await db.collection(S.DB.collectionName).getDocuments().count
        print("count before: \(countBefore)")
        let newEvent = Event(name: "Test\(Int.random(in: 0 ... 1000))", description: "desc", place: "All", dateTime: Date.now)
        try await EventHandler.addNewEvent(event: newEvent)
        let countAfter = try await db.collection(S.DB.collectionName).getDocuments().count
        print("count after: \(countAfter)")
        XCTAssert(countBefore + 1 == countAfter, "Expected count: \(countBefore + 1), actual count: \(countAfter)")
    }
    
    func testDBRemoveAccess() async throws {
        //get count
        let countBefore = try await db.collection(S.DB.collectionName).getDocuments().count
        print("count before: \(countBefore)")
        let doc = try await db.collection(S.DB.collectionName).getDocuments().documents.first
        let nameForDelete = doc?.data()[S.DB.nameField] as? String
        guard nameForDelete != nil else {
            XCTFail("Can not get first doc name")
            return
        }
        print("Removing item with name: \(String(describing: nameForDelete))")
        try await EventHandler.deleteEvent(name: nameForDelete!)
       
        let countAfter = try await db.collection(S.DB.collectionName).getDocuments().count
        print("count after: \(countAfter)")
        XCTAssert(countBefore - 1 == countAfter, "Expected count: \(countBefore - 1), actual count: \(countAfter)")
    }
    

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }   
}


