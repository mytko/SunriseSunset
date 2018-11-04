//
//  DailySunInfoCell.swift
//  SunriseSunset
//
//  Created by Vasyl Mytko on 11/2/18.
//  Copyright © 2018 Vasyl Mytko. All rights reserved.
//

import UIKit

class DailySunInfoCell: UICollectionViewCell {
    @IBOutlet weak var dayTitleLabel: UILabel!
    
    @IBOutlet weak var sunriseLabel: UILabel!
    
    @IBOutlet weak var sunsetLabel: UILabel!
    
    private let formatter = DateFormatter()
    
    var sunInfo: SolarInfo! {
        didSet {
            updateCell()
        }
    }
    
    func updateCell() {
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: sunInfo.date! as Date)
        dayTitleLabel.text = calendar.shortWeekdaySymbols[day - 1]
        sunriseLabel.text = convertTime(sunInfo.sunrise ?? "")
        sunsetLabel.text = convertTime(sunInfo.sunset ?? "")
    }
    
    private func convertTime(_ time: String) -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        formatter.dateFormat = "hh:mm:ss a"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        var date = formatter.date(from: time)!
        date = calendar.date(byAdding: .minute, value: Int(sunInfo.location?.utcOffset ?? 0), to: date)!
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
}

