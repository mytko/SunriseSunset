//
//  Location+CoreDataProperties.swift
//  SunriseSunset
//
//  Created by Vasyl Mytko on 11/4/18.
//  Copyright © 2018 Vasyl Mytko. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var administrativeArea: String?
    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var utcOffset: Int64
    @NSManaged public var solarInfo: NSSet?

}

// MARK: Generated accessors for solarInfo
extension Location {

    @objc(addSolarInfoObject:)
    @NSManaged public func addToSolarInfo(_ value: SolarInfo)

    @objc(removeSolarInfoObject:)
    @NSManaged public func removeFromSolarInfo(_ value: SolarInfo)

    @objc(addSolarInfo:)
    @NSManaged public func addToSolarInfo(_ values: NSSet)

    @objc(removeSolarInfo:)
    @NSManaged public func removeFromSolarInfo(_ values: NSSet)

}
