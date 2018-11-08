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

typealias DetailInfo = (description: String, info: String)

public class SolarInfo: NSManagedObject {
    
    static func initWith(info: SunriseSunsetInfo) -> SolarInfo {
        let entity = NSEntityDescription.entity(forEntityName: "SolarInfo", in: CoreDataStack.shared.managedContext)!
        let solarInfo = SolarInfo(entity: entity, insertInto: nil)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        solarInfo.date = formatter.date(from: info.date!)! as NSDate
        solarInfo.sunrise = info.results.sunrise
        solarInfo.sunset = info.results.sunset
        solarInfo.dayLength = info.results.dayLength
        solarInfo.twilightBegin = info.results.twilightBegin
        solarInfo.twilightEnd = info.results.twilightEnd
        solarInfo.astroTwilightBegin = info.results.astroLightBegin
        solarInfo.astroTwilightEnd = info.results.astroLightEnd
        solarInfo.nauticalTwilightBegin = info.results.nauticalLightBegin
        solarInfo.nauticalTwilightEnd = info.results.nauticalLightEnd
        solarInfo.solarNoon = info.results.solarNoon
        return solarInfo
    }
    
    func detailInfo() -> [DetailInfo] {
        let array: [DetailInfo] = [
            ("Day length", self.dayLength!),
            ("Solar noon", self.solarNoon!.convertTwelveHour(utcOffset: Int(location!.utcOffset))!),
            ("Twilight begin", self.twilightBegin!.convertTwelveHour(utcOffset: Int(location!.utcOffset))!),
            ("Twilight end", self.twilightEnd!.convertTwelveHour(utcOffset: Int(location!.utcOffset))!),
            ("Astro twilight begin", self.astroTwilightBegin!.convertTwelveHour(utcOffset: Int(location!.utcOffset))!),
            ("Astro twilight end", self.astroTwilightEnd!.convertTwelveHour(utcOffset: Int(location!.utcOffset))!),
            ("Nautical twilight begin", self.nauticalTwilightBegin!.convertTwelveHour(utcOffset: Int(location!.utcOffset))!),
            ("Nautical twilight end", self.nauticalTwilightEnd!.convertTwelveHour(utcOffset: Int(location!.utcOffset))!)
        ]
        return array
    }
}
