//
//  TableViewCell.swift
//  ReminderWithWeather
//
//  Created by Polina Sadouskaya on 28/03/2023.
//

import UIKit



class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var cellView: UIView!    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.cornerRadius = cellView.frame.size.height/5
        cellView.backgroundColor = UIColor(named: "white")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}


