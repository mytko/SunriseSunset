//
//  LocationCell.swift
//  SunriseSunset
//
//  Created by Vasyl Mytko on 10/30/18.
//  Copyright © 2018 Vasyl Mytko. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var locationDescriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    func setupCell(location: Location) {
        sunriseLabel.text = "6:21"
        sunsetLabel.text = "17:58"
        locationDescriptionLabel.text = location.city 
        timeLabel.text = location.time
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 7
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    }
}
