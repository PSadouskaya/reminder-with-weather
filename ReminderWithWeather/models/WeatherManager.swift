//
//  WeatherManager.swift
//  ReminderWithWeather
//
//  Created by Polina Sadouskaya on 03/04/2023.
//

import Foundation
import UIKit

protocol WeatherManagerDelegate {
    func didUpdateWeather(tempr: Double)
    func didFailWithError(error:Error)
}

struct WeatherManager {
    var delegate: WeatherManagerDelegate?
    
    
    var url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline"
    var key = "VUHUAHX9KV62NFUUE56UQEP49"
    //https://api.openweathermap.org/data/3.0/onecall/timemachine?appid=80443a54dc5e78879818a871ad739fd0&q=Bali&units=metric
    //https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/38.9697,-77.385/2022-03-04/2022-03-04?key=VUHUAHX9KV62NFUUE56UQEP49
   
    func fetchWeather(lat: Double, lon: Double, date: Date){
        print("date is \(Helper.getDateStringWithFormat(date: date, format: "YYYY-MM-dd")) place - \(lat),\(lon) ")
        //print("Date is \(date) and timestamp for it is \(timestamp)")
        let urlString = "\(url)/\(lat),\(lon)/\(Helper.getDateStringWithFormat(date: date, format: "YYYY-MM-dd"))/\(Helper.getDateStringWithFormat(date: date, format: "YYYY-MM-dd"))?key=\(key)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString : String){
        
            // 1.Create url
        if let url = URL(string: urlString){
            // 2. Create session
            let session = URLSession(configuration: .default)
            // 3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                print("Response: \(String(describing: response))")
                if error != nil {
                    print("Error on request weather: \(error!)")
                    self.delegate?.didFailWithError(error:error!)
                    return
                }
                if let safeData = data {
                    let result = self.parseJson(weatherData: safeData)
                    self.delegate?.didUpdateWeather(tempr: result!)
                }
            }
            // 4. Start the task
            task.resume()
        }
    }
    
    func parseJson(weatherData: Data) -> Double?{
        let decoder = JSONDecoder()
        print(weatherData)
        do {
            let decodedData = try decoder.decode(WeatherDataModel.self, from: weatherData)
            let temperature = decodedData.days[0].temp
            let date = decodedData.days[0].datetime
            //
            
            print("Temperature is \(temperature) for date \(date)")
            return temperature
        } catch {
            print(error)
            return nil
        }
    }
    
    func getColorByTemperature(tempr: Double) -> UIColor {
        var color = UIColor(red: 0.95, green: 0.91, blue: 1.00, alpha: 0.00)
        switch tempr {
        case -50 ... -10.0 : color = UIColor(red: 0.38, green: 0.59, blue: 0.71, alpha: 1.00)
        case -9.99 ... -5.0 : color = UIColor(red: 0.58, green: 0.75, blue: 0.81, alpha: 1.00)
        case -4.99 ... -1.0 : color = UIColor(red: 0.74, green: 0.80, blue: 0.84, alpha: 1.00)
        case -0.99 ... 0.0 : color = UIColor(red: 0.93, green: 0.91, blue: 0.85, alpha: 1.00)
            
        case 0.01 ... 5.0 : color = UIColor(red: 0.92, green: 0.78, blue: 0.78, alpha: 1.00)
        case 5.01 ... 10.0 : color = UIColor(red: 0.98, green: 0.71, blue: 0.82, alpha: 1.00)
        case 10.01 ... 15.0 : color = UIColor(red: 1.00, green: 0.56, blue: 0.62, alpha: 1.00)
        case 15.01 ... 25.0 : color = UIColor(red: 1.00, green: 0.35, blue: 0.48, alpha: 1.00)
        case 25.01 ... 35.0 : color = UIColor(red: 0.96, green: 0.31, blue: 0.31, alpha: 1.00)
        case 35.01 ... 100.0 : color = UIColor(red: 0.57, green: 0.19, blue: 0.46, alpha: 1.00)
        default:
            color = UIColor(red: 0.95, green: 0.91, blue: 1.00, alpha: 0.00)
        }
        return color
    }
}
