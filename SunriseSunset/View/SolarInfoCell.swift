//
//  SolarInfoCell.swift
//  SunriseSunset
//
//  Created by Vasyl Mytko on 11/3/18.
//  Copyright © 2018 Vasyl Mytko. All rights reserved.
//

import UIKit

class SolarInfoCell: UICollectionViewCell {

    @IBOutlet weak var dayLengthLabel: UILabel!
    @IBOutlet weak var twilightBeginLabel: UILabel!
    @IBOutlet weak var twilightEndLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var locationDescriptionLabel: UILabel!
    @IBOutlet weak var upcomingDaysInfoCollectionView: UICollectionView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var sunWeekInfo: [SolarInfo] = []
    
    func updateCell(location: Location, solarInfo: SolarInfo) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        locationDescriptionLabel.text = location.city
        dateLabel.text = dateFormatter.string(for: solarInfo.date! as Date)
        sunsetLabel.text = solarInfo.sunset?.convertTwelveHour(utcOffset: Int(location.utcOffset))
        sunriseLabel.text = solarInfo.sunrise?.convertTwelveHour(utcOffset: Int(location.utcOffset))
        twilightEndLabel.text = solarInfo.twilightEnd?.convertTwelveHour(utcOffset: Int(location.utcOffset))
        twilightBeginLabel.text = solarInfo.twilightBegin?.convertTwelveHour(utcOffset: Int(location.utcOffset))
        dayLengthLabel.text = solarInfo.dayLength
        sunWeekInfo = location.solarInformation
        upcomingDaysInfoCollectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        upcomingDaysInfoCollectionView.dataSource = self
        upcomingDaysInfoCollectionView.layer.borderColor = UIColor.white.cgColor
        upcomingDaysInfoCollectionView.layer.borderWidth = 0.4
    }
}

extension SolarInfoCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection
        section: Int) -> Int {
        return sunWeekInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DailySunInfoCell
        cell.sunInfo = sunWeekInfo[indexPath.item]
        return cell
    }
}

