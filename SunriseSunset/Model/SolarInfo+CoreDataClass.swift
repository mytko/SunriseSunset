//
//  SolarInfo+CoreDataClass.swift
//  SunriseSunset
//
//  Created by Vasyl Mytko on 10/30/18.
//  Copyright © 2018 Vasyl Mytko. All rights reserved.
//
//

import Foundation
import CoreData


public class SolarInfo: NSManagedObject {
    
    static func initWith(info: SunriseSunsetInfo) -> SolarInfo {
        let solarInfo = SolarInfo(context: CoreDataStack.shared.managedContext)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        solarInfo.date = formatter.date(from: info.date!)! as NSDate
        solarInfo.sunrise = info.results.sunrise
        solarInfo.sunset = info.results.sunset
        solarInfo.dayLength = info.results.dayLength
        solarInfo.twilightBegin = info.results.twilightBegin
        solarInfo.twilightEnd = info.results.twilightEnd
        return solarInfo
    }
    
}
