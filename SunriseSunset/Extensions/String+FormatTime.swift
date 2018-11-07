//
//  String+FormatTime.swift
//  SunriseSunset
//
//  Created by Vasyl Mytko on 11/7/18.
//  Copyright © 2018 Vasyl Mytko. All rights reserved.
//

import Foundation

extension String {
    func convertTwelveHour(utcOffset: Int) -> String? {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        formatter.dateFormat = "hh:mm:ss a"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        
        guard var date = formatter.date(from: self) else {
            return nil
        }
        
        date = calendar.date(byAdding: .minute, value: utcOffset, to: date)!
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
