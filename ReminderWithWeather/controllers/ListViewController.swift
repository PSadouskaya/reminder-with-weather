//
//  ViewController.swift
//  ReminderWithWeather
//
//  Created by Polina Sadouskaya on 27/03/2023.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

protocol CellAction {
    func moveToAnotherPageWithValue(value: String)
}

extension ListViewController : CellAction {
    func moveToAnotherPageWithValue(value: String) {
        
    }
}

class ListViewController: UIViewController {    
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var filterLabel: UIButton!
    @IBOutlet weak var addNewImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var listView: UITableView!
    
    let db = Firestore.firestore()
    
    var currentFilter = S.Filter.items[0]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // set up labels
        
        nameLabel.text = S.appName
        filterLabel.setTitle(S.Filter.menuName, for:.normal)
        
        
        //configure filter
        filterButton.showsMenuAsPrimaryAction = true
        let menuHandler = MenuItemsHandler(delegate: self)
        menuHandler.configure()
        loadEvents()
        
        //configure add new image click action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        addNewImage.isUserInteractionEnabled = true
        addNewImage.addGestureRecognizer(tapGestureRecognizer)
        
        //configure table view
        listView.dataSource = self
        listView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "ListViewItem")
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //let tappedImage = tapGestureRecognizer.view as! UIImageView
        openNewItemView()
    }
    
    func openNewItemView(){
        self.performSegue(withIdentifier: S.Segues.createNew, sender: self)
    }
    func openItemView(value: String){
        let sender = ["name": value]
        self.performSegue(withIdentifier: S.Segues.viewItem, sender: sender)
    }
    
    func loadEvents(){
        print(filterButton.currentTitle!)
        if filterButton.currentTitle! == "All" {
            EventHandler.loadAllEvents(view: listView)
        } else {
            EventHandler.loadFilteredEvents(view: listView, fieldValue: filterButton.currentTitle!)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == S.Segues.viewItem) {
          let destView = segue.destination as! ItemViewController
          let object = sender as! [String: Any?]
            destView.name = object["name"] as? String ?? "undefined"
       }
    }

}

extension ListViewController: UITableViewDataSource {
    @objc func cellTapped(cellTapGestureRecognizer: UITapGestureRecognizer) {
        let tappedCell = cellTapGestureRecognizer.view as! TableViewCell
        openItemView(value: tappedCell.nameLabel.text!)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventHandler.eventsCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped(cellTapGestureRecognizer:)))
        
        let event = EventHandler.eventsCollection[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewItem", for: indexPath) as! TableViewCell
        cell.nameLabel.text = event.name
        cell.addGestureRecognizer(cellTapGestureRecognizer)        
        cell.dateLabel.text = Helper.getDateStringWithFormat(date: event.dateTime, format: "dd-MM-YYYY")
        switch event.place {
        case S.Filter.items[0] : cell.placeImage.image = UIImage(systemName: S.Icons.all)
        case S.Filter.items[1]: cell.placeImage.image = UIImage(systemName: S.Icons.inbound)
        case S.Filter.items[2]: cell.placeImage.image = UIImage(systemName: S.Icons.outbound)
        default:
            cell.placeImage.image = UIImage(systemName: "circle")
        }        
        return cell
    }
}

extension ListViewController: HasMenuButton {
    func updateBtnTitle(title: String) {
        filterButton.setTitle(title, for: .normal)
        print("Filter button title changed")
        loadEvents()
    }
    
    func setMenuForBtn(menu: UIMenu) {
        filterButton.menu=menu
    }
    
    
}


