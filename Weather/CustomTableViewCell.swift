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
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadItem(date: String, icon: UIImage, maxTemp: Int, minTemp: Int) {
        dayLabel.text = date
        weatherIcon.image = icon
        maxTempLabel.text = "\(maxTemp)°"
        minTempLabel.text = "\(minTemp)°"
    }

}
