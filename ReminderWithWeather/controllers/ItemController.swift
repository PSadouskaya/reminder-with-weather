//
//  ItemController.swift
//  ReminderWithWeather
//
//  Created by Polina Sadouskaya on 27/03/2023.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ItemController: UIViewController {
    
    var state: String = "new"
    var event: Event = Event(name: "", description: "", place: "", dateTime: Date.now)
    var oldName: String = ""
    
    @IBOutlet weak var placeButton: UIButton!
    @IBOutlet weak var itemDesc: UITextField!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var itemName: UITextField!

    @IBOutlet weak var saveButton: UIButton!    
    
    @IBOutlet weak var itemPlaceLabel: UILabel!
    @IBOutlet weak var itemDateLabel: UILabel!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    
    let db = Firestore.firestore()
    
    
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if let eventName = itemName.text,
           let eventDescription = itemDesc.text,
           let eventType = placeButton.currentTitle
            
            
        {
            print("Old name: \(oldName)")
            print("new name: \(event.name)")
            let event = Event(name: eventName, description: eventDescription, place: eventType, dateTime: datePickerView.date)
            if eventName != "" {
                if state == "new"{
                    if EventHandler.checkNameUnique(name: event.name) == 0 {
                        EventHandler.addNewEvent(event: event)
                        print("Data successfully saved to db")
                        self.dismiss(animated: true)
                    } else {
                        showAlert(title: S.Message.duplicateName)
                    }
                }
                if state == "update" {
                    if event.name == oldName {
                        EventHandler.updateEvent(event: event, name: oldName)
                        
                        self.navigationController?.popToRootViewController(animated: true)
                    } else {
                        print(EventHandler.eventsCollection)
                        if EventHandler.checkNameUnique(name: event.name) == 0 {
                            EventHandler.updateEvent(event: event, name: oldName)
                            self.navigationController?.popToRootViewController(animated: true)
                        } else {
                            showAlert(title: S.Message.duplicateName)
                        }
                    }
                }
            } else {
                showAlert(title: S.Message.populateAllFields)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        appName.text = S.appName
        itemNameLabel.text = S.itemNameLabel
        itemDescriptionLabel.text = S.itemDescLabel
        itemDateLabel.text = S.itemDateLabel
        itemPlaceLabel.text = S.itemPlaceLabel
        
        placeButton.setTitle(S.placeButtonText, for: .normal)
        saveButton.setTitle(S.saveButtonText, for: .normal)
        
        let menuHandler = MenuItemsHandler(delegate: self)
        menuHandler.configure()
        
        if state == "update" {
            itemName.text = event.name
            itemDesc.text = event.description
            placeButton.setTitle(event.place, for: .normal)
            itemPlaceLabel.text = event.place
            datePickerView.date = event.dateTime
        }
        
    }
    
    func showAlert(title: String){
        let alert = UIAlertController(title: S.Message.errorTitle, message: title, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            alert.dismiss(animated: true)
        }))
        DispatchQueue.main.async {
        self.present(alert, animated: false, completion: nil)
        }
    }
    
}

extension ItemController:HasMenuButton {
    func updateBtnTitle(title: String) {
        placeButton.setTitle(title, for: .normal)
    }
    
    func setMenuForBtn(menu: UIMenu) {
        placeButton.menu = menu
    }
    
    
}
