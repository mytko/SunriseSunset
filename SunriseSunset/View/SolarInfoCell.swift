//
//  SolarInfoCell.swift
//  SunriseSunset
//
//  Created by Vasyl Mytko on 11/3/18.
//  Copyright © 2018 Vasyl Mytko. All rights reserved.
//

import UIKit

class SolarInfoCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var locationDescriptionLabel: UILabel!
    @IBOutlet weak var upcomingDaysInfoCollectionView: UICollectionView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detainInfoCollectionView: UICollectionView!
    
    var sunWeekInfo: [SolarInfo] = []
    
    var detailInfo: [DetailInfo] = []
    
    func updateCell(location: Location, solarInfo: SolarInfo) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        locationDescriptionLabel.text = location.city
        dateLabel.text = dateFormatter.string(for: solarInfo.date! as Date)
        sunsetLabel.text = solarInfo.sunset?.convertTwelveHour(utcOffset: Int(location.utcOffset))
        sunriseLabel.text = solarInfo.sunrise?.convertTwelveHour(utcOffset: Int(location.utcOffset))
        sunWeekInfo = location.solarInformation
        detailInfo = solarInfo.detailInfo()
        upcomingDaysInfoCollectionView.reloadData()
        detainInfoCollectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        upcomingDaysInfoCollectionView.dataSource = self
        upcomingDaysInfoCollectionView.delegate = self
        detainInfoCollectionView.dataSource = self
        detainInfoCollectionView.delegate = self
        upcomingDaysInfoCollectionView.layer.borderColor = UIColor.white.cgColor
        upcomingDaysInfoCollectionView.layer.borderWidth = 0.4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == detainInfoCollectionView {
            return CGSize(width: collectionView.frame.width / 2, height: 80)
        } else {
            return CGSize(width: collectionView.frame.width / 3.5, height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension SolarInfoCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection
        section: Int) -> Int {
        if collectionView == upcomingDaysInfoCollectionView {
            return sunWeekInfo.count
        } else {
            return detailInfo.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == upcomingDaysInfoCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DailySunInfoCell
            cell.sunInfo = sunWeekInfo[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailInfoCell", for: indexPath) as! DetailInfoCell
            cell.descriptionLabel.text = detailInfo[indexPath.item].description
            cell.infoLabel.text = detailInfo[indexPath.item].info
            return cell
        }
    }
}


