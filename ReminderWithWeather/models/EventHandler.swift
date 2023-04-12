//
//  EventHandler.swift
//  ReminderWithWeather
//
//  Created by Polina Sadouskaya on 28/03/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseCore

struct EventHandler {
    static let db = Firestore.firestore()
    
    static var eventsCollection:[Event] = []
    
    static func loadAllEvents(view: UITableView){
        
        db.collection(S.DB.collectionName).order(by: S.DB.dateField).addSnapshotListener() { (querySnapshot, err) in
            print("started load data from database")
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                eventsCollection.removeAll()
                print("removed all from collection")
                if let queryDocuments = querySnapshot?.documents {
                    for doc in queryDocuments {
                        if let name = doc.data()[S.DB.nameField] as? String,
                           let place = doc.data()[S.DB.placeField] as? String,
                           let timestamp = doc.data()[S.DB.dateField] as? Timestamp,
                           let description = doc.data()[S.DB.decriptionField] as? String {
                            //converting date from timestamp to date
                            let int64Value: Int64 = timestamp.seconds
                            let doubleValue = NSNumber(value: int64Value).doubleValue
                            let date = NSDate(timeIntervalSince1970: doubleValue)
                            let ev = Event(name: name, description: description, place: place, dateTime: date as Date)
                            eventsCollection.append(ev)
                            
                            DispatchQueue.main.async {
                                view.reloadData()
                                //autoscroll
                                let indexpath = IndexPath(row: eventsCollection.count-1, section: 0)
                                view.scrollToRow(at: indexpath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
            print("Loaded \(eventsCollection.count) records")
        }
    }
    
    static func loadFilteredEvents(view: UITableView, fieldValue: String){
        
        db.collection(S.DB.collectionName).order(by: S.DB.dateField).addSnapshotListener() { (querySnapshot, err) in
            print("started filtered load data from database")
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                eventsCollection.removeAll()
                if let queryDocuments = querySnapshot?.documents {
                    for doc in queryDocuments {
                        if let name = doc.data()[S.DB.nameField] as? String,
                           let place = doc.data()[S.DB.placeField] as? String,
                           let timestamp = doc.data()[S.DB.dateField] as? Timestamp,
                           let description = doc.data()[S.DB.decriptionField] as? String {
                            if place == fieldValue {
                                //converting date from timestamp to date
                                let date = Helper.getDateFromTimestamp(timestamp: timestamp)
                                let ev = Event(name: name, description: description, place: place, dateTime: date as Date)
                                eventsCollection.append(ev)
                                
                                DispatchQueue.main.async {
                                    view.reloadData()
                                    //autoscroll
                                    let indexpath = IndexPath(row: eventsCollection.count-1, section: 0)
                                    view.scrollToRow(at: indexpath, at: .top, animated: true)
                                }
                            }
                            
                        }
                    }
                }
            }
            print("Loaded \(eventsCollection.count) records")
        }
    }
    
    static func addNewEvent(event : Event){
            db.collection(S.DB.collectionName).addDocument(data:
                [
                    S.DB.nameField : event.name,
                    S.DB.decriptionField : event.description,
                    S.DB.placeField: event.place,
                    S.DB.dateField: event.dateTime
                ]
            )
    }
    
    static func updateEvent(event: Event, name: String){
        db.collection(S.DB.collectionName).whereField(S.DB.nameField, isEqualTo: name).getDocuments { querySnapshot, error in
            if let err = error {
                print("Error on get doc for update \(err)")
            } else {
                for doc in querySnapshot!.documents {
                    let docId = doc.documentID
                    db.collection(S.DB.collectionName).document(docId).updateData([S.DB.nameField : event.name,
                                                                                    S.DB.decriptionField: event.description,
                                                                                    S.DB.placeField: event.place,
                                                                                    S.DB.dateField: event.dateTime])
                    
                }                
            }
        }
        
    }
    
    
    static func deleteEvent(name: String){
        // Create a reference to the cities collection
        db.collection(S.DB.collectionName).whereField("name", isEqualTo: name).getDocuments(){(querySnapshot, err) in
            if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            db.collection(S.DB.collectionName).document(document.documentID).delete()
                            print("document with name \(name) deleted")
                        }
                    }
        }
    }
    
    static func checkNameUnique(name: String) -> Int {
        var num = 0
        for e in eventsCollection {
            if e.name == name {
                num += 1
            }
        }
        print("Found with name \(name) : \(num)")
        return num
    }
}
