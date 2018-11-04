//
//  SolarInfo+CoreDataProperties.swift
//  SunriseSunset
//
//  Created by Vasyl Mytko on 11/4/18.
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
    @NSManaged public var sunrise: String?
    @NSManaged public var sunset: String?
    @NSManaged public var dayLength: String?
    @NSManaged public var twilightBegin: String?
    @NSManaged public var twilightEnd: String?
    @NSManaged public var location: Location?

}
