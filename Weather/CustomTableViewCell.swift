//
//  CustomTableViewCell.swift
//  Weather
//
//  Created by Ibrahim Almakky on 29/11/2014.
//  Copyright (c) 2014 Ibrahim Almakky. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadItem(date: String) {
        dayLabel.text = "Hello"
    }

}
