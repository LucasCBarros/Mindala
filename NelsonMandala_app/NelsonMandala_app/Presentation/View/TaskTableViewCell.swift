//
//  TaskTableViewCell.swift
//  NelsonMandala_app
//
//  Created by Lucas Santos on 25/10/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit

@IBDesignable
class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var taskIcon: UIImageView!
    @IBOutlet weak var cardView: CardTaskCell!
    
    override func layoutSubviews() {
        // Initialization code
        self.backgroundColor = UIColor.clear
        
    }

    /*override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }*/

}
