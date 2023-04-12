//
//  Strings.swift
//  ReminderWithWeather
//
//  Created by Polina Sadouskaya on 28/03/2023.
//

import Foundation

struct S {
    static let appName = "Rainbow Reminder"
    
    static let itemNameLabel = "Title of event:"
    static let itemDescLabel = "Description of event:"
    static let itemDateLabel = "Date of event:"
    static let itemPlaceLabel = "Type of event:"
    
    static let placeButtonText = "Select the place"
    static let saveButtonText = "Save"
    static let deleteButtonText = "Delete"
    static let backButtonText = "Back"
    static let editButtonText = "Edit"
    
    struct Message {
        static let errorTitle = "Error"
        static let populateAllFields = "Please, populdate all the fields."
        static let duplicateName = "Event with such name is already created. Please, choose another one."
    }
    
    struct Segues {
        static let createNew = "newItemSeque"
        static let viewItem = "viewItemSegue"
        static let editItem = "editItemSegue"
        static let listView = "showListView"
    }
    
    struct Filter {
        static let menuName="Filter by place"
        static let items = ["All","Inside events", "Outside events"]
    }
    
    struct DB {
        static let collectionName = "events"
        static let nameField = "name"
        static let decriptionField = "description"
        static let placeField = "place"
        static let dateField = "dateTime"
        
        static let dateCreated = "createdDate"
    }
    
    struct Icons {
        static let all = "circle"
        static let inbound = "house.circle"
        static let outbound = "sun.max.circle"
    }
}
