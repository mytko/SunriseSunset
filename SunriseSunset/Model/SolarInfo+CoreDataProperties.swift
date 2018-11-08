//
//  SolarInfo+CoreDataProperties.swift
//  SunriseSunset
//
//  Created by Vasyl Mytko on 11/8/18.
//  Copyright © 2018 Vasyl Mytko. All rights reserved.
//
//

import Foundation
import CoreData


extension SolarInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SolarInfo> {
        return NSFetchRequest<SolarInfo>(entityName: "SolarInfo")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var dayLength: String?
    @NSManaged public var sunrise: String?
    @NSManaged public var sunset: String?
    @NSManaged public var twilightBegin: String?
    @NSManaged public var twilightEnd: String?
    @NSManaged public var astroTwilightBegin: String?
    @NSManaged public var astroTwilightEnd: String?
    @NSManaged public var nauticalTwilightBegin: String?
    @NSManaged public var nauticalTwilightEnd: String?
    @NSManaged public var solarNoon: String?
    @NSManaged public var location: Location?

}
