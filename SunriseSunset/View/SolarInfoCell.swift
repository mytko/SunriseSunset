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
    
    var location: Location! {
        didSet {
            updateCell()
        }
    }
    
    private func convertTime(_ time: String) -> String {
        let current = Location.currentLocationFrom(userDefaults: UserDefaults.standard)!
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        formatter.dateFormat = "hh:mm:ss a"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        var date = formatter.date(from: time)!
        date = calendar.date(byAdding: .minute, value: Int(location.utcOffset), to: date)!
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    func updateCell() {
        let today = location.solarInformation.first!
        print(today.sunset)
        print(convertTime(today.sunset!))
        sunsetLabel.text = convertTime(today.sunset ?? "")
        sunriseLabel.text = convertTime(today.sunrise ?? "")
        twilightEndLabel.text = today.twilightEnd
        twilightBeginLabel.text = today.twilightBegin
        dayLengthLabel.text = today.dayLength
        upcomingDaysInfoCollectionView.reloadData()
        locationDescriptionLabel.text = location.city
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        upcomingDaysInfoCollectionView.dataSource = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        upcomingDaysInfoCollectionView.layer.borderColor = UIColor.white.cgColor
        upcomingDaysInfoCollectionView.layer.borderWidth = 0.4
    }
}

extension SolarInfoCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection
        section: Int) -> Int {
        return location.solarInformation.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DailySunInfoCell
        cell.sunInfo = location.solarInformation[indexPath.item]
        return cell
    }
}
