//
//  ItemViewController.swift
//  ReminderWithWeather
//
//  Created by Polina Sadouskaya on 01/04/2023.
//

import UIKit
import CoreLocation

class ItemViewController: UIViewController {
    
    var name = ""
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var weatherField: UITextField!
    
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    var data = Event(name: "", description: "", place: "", dateTime: Date.now)
    
    var lat:Double = 0
    var lon:Double = 0
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        if name != "" {
            EventHandler.deleteEvent(name: name)
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            print("Something went wrong")
        }
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        let event = EventHandler.eventsCollection.first(where: {$0.name == name})
        let sender = ["state": "update", "event": event as Any, "oldName": name]
        self.performSegue(withIdentifier: S.Segues.editItem, sender: sender)
    }
    
    @IBOutlet weak var appLabel: UILabel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == S.Segues.editItem) {
          let destView = segue.destination as! ItemController
          let object = sender as! [String: Any?]
            destView.state = object["state"] as? String ?? "undefined"
            destView.event = object["event"] as? Event ?? Event(name: "", description: "", place: "", dateTime: Date.now)
            destView.oldName = object["oldName"] as? String ?? "undefined"
       }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate=self
        weatherManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        //name buttons
        appLabel.text = S.appName
        deleteButton.setTitle(S.deleteButtonText, for: .normal)      
        editButton.setTitle(S.editButtonText, for: .normal)

        // get data for event
        if let d = EventHandler.eventsCollection.first(where: {$0.name == name}) {
            data = d
            nameLabel.text = data.name
            descLabel.text = data.description
            placeLabel.text = data.place
            //dateLabel.text = data.dateTime.formatted()
            dateLabel.text = Helper.getDateStringWithFormat(date: data.dateTime, format: "dd-MM-YYYY")
            print("Starting request location")
            locationManager.requestLocation()
            
        }
    }
}

extension ItemViewController: WeatherManagerDelegate {
    func didUpdateWeather(tempr: Double){
        DispatchQueue.main.async{
            //let data = EventHandler.eventsCollection.first(where: {$0.name == self.name})
            let t = Helper.getCelsiusFromFarenheit(tempr: tempr)
            self.weatherLabel.text = "Current forecast for this day is \(t)°C"
            let color = self.weatherManager.getColorByTemperature(tempr: t)
            self.weatherLabel.backgroundColor = color
        }
        
    }
    func didFailWithError(error: Error) {
        print("Weather manager delegate fail with error \(error)")
    }
}

extension ItemViewController: CLLocationManagerDelegate {
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            lat = location.coordinate.latitude
            lon = location.coordinate.longitude
            //lat = 54.37
            //lon = 18.63
            print("Data pased to fetch weather \(data.dateTime) \(lon) \(lat)")
            print("Starting fetch weather")
            weatherManager.fetchWeather(lat: lat, lon: lon, date: data.dateTime)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error in location manager \(error)")
    }
}
