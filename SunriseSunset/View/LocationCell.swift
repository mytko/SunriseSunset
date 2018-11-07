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
        let sunInfo = location.solarInformation.first!
        sunriseLabel.text = sunInfo.sunrise?.convertTwelveHour(utcOffset: Int(location.utcOffset))
        sunsetLabel.text = sunInfo.sunset?.convertTwelveHour(utcOffset: Int(location.utcOffset))
        locationDescriptionLabel.text = location.city 
        timeLabel.text = location.time
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    }
}
