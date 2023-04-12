//
//  MenuItemsHandler.swift
//  ReminderWithWeather
//
//  Created by Polina Sadouskaya on 28/03/2023.
//

import Foundation
import UIKit

protocol HasMenuButton {
    func updateBtnTitle(title:String)
    func setMenuForBtn(menu: UIMenu)
}

class MenuItemsHandler {
    var delegate: HasMenuButton
    var menuItems = S.Filter.items
    var menuElements:[UIAction]=[]
    var currentTitle:String=""
    
    init(delegate: HasMenuButton) {
        self.delegate = delegate        
    }
    
    func configure(){
        //configure the filter button
        self.currentTitle = menuItems[0]
        for i in self.menuItems {
            let act = UIAction(title: i) { action in
                self.currentTitle = i
                self.delegate.updateBtnTitle(title: self.currentTitle)                
            }
            self.menuElements.append(act)
        }
        
        let menu = UIMenu(children: menuElements)
        delegate.updateBtnTitle(title: currentTitle)
        delegate.setMenuForBtn(menu: menu)
    }
    
    
}
