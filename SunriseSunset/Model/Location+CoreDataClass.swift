//
//  Location+CoreDataClass.swift
//  SunriseSunset
//
//  Created by Vasyl Mytko on 10/30/18.
//  Copyright © 2018 Vasyl Mytko. All rights reserved.
//
//

import Foundation
import CoreData
import CoreLocation

public class Location: NSManagedObject {
    
    var time: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "HH:mm"
        let userDefaults = UserDefaults.standard
        let currentLocationUtcOffset = userDefaults.double(forKey: "utcOffset")
        let calendar = Calendar.current
        let currentTime = calendar.date(byAdding: .minute, value: Int(utcOffset) - Int(currentLocationUtcOffset), to: Date())!
        return dateFormatter.string(from: currentTime)
    }
    
    public var solarInformation: [SolarInfo] {
        return (solarInfo?.map { $0 as! SolarInfo } ?? [])
            .sorted { ($0.date! as Date) < ($1.date! as Date) }
    }
    
    public func solarInfoFor(date: Date) -> SolarInfo? {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "yyyy-MM-dd"
        
        let filteredInfo = solarInformation.filter { formatter.string(from: $0.date! as Date) == formatter.string(from: date) }.first
        return filteredInfo
    }
    
    public static func deleteLocation(_ location: Location) {
        let context = CoreDataStack.shared.managedContext
        let request: NSFetchRequest<Location> = Location.fetchRequest()
        let predicate = NSPredicate(format: "city == %@", location.city!)
        request.predicate = predicate
        do {
            let locations = try context.fetch(request)
            if !locations.isEmpty {
                context.delete(locations.first!)
            }
        } catch {
            fatalError()
        }
    }
    
    func saveAsCurrentLocation() {
        let userDefaults = UserDefaults.standard
    
        if let currentLocation = Location.currentLocationFrom(userDefaults: userDefaults) {
            Location.deleteLocation(currentLocation)
        }
       
        saveLocationToUserDefaults(userDefaults)
        
        self.saveLocation()
    }
    
    public static func initWith(placeDetail: PlaceDetail) -> Location {
        let entity = NSEntityDescription.entity(forEntityName: "Location", in: CoreDataStack.shared.managedContext)!
        let location = Location(entity: entity, insertInto: nil)
        location.city = placeDetail.result.description
        location.latitude = placeDetail.result.geometry.location.lat
        location.longitude = placeDetail.result.geometry.location.lng
        location.utcOffset = Int64(placeDetail.result.utcOffset)
        return location
    }
    
    private func saveLocationToUserDefaults(_ userDefaults: UserDefaults) {
        let utcOffset = Double(TimeZone.current.secondsFromGMT()) / 60.0
        userDefaults.set(utcOffset, forKey: "utcOffset")
        userDefaults.set(country, forKey: "country")
        userDefaults.set(city, forKey: "city")
        userDefaults.set(administrativeArea, forKey: "administrativeArea")
        userDefaults.set(latitude, forKey: "latitude")
        userDefaults.set(longitude, forKey: "longitude")
        userDefaults.set(Date(), forKey: "lastTimeOpened")
    }

    func saveLocation() {
        CoreDataStack.shared.managedContext.insert(self)
        solarInfo!.forEach { CoreDataStack.shared.managedContext.insert($0 as! NSManagedObject) }
        CoreDataStack.shared.saveContext()
    }
    
    static public func currentLocationFrom(userDefaults: UserDefaults) -> Location? {
        let entity = NSEntityDescription.entity(forEntityName: "Location", in: CoreDataStack.shared.managedContext)!
        let currentLocation = Location(entity: entity, insertInto: nil)
        guard let city = userDefaults.string(forKey: "city"),
            let country = userDefaults.string(forKey: "country") else {
                return nil
        }
        currentLocation.city = city
        currentLocation.country = country
        currentLocation.administrativeArea = userDefaults.string(forKey: "administrativeArea") ?? ""
        currentLocation.latitude = userDefaults.double(forKey: "latitude")
        currentLocation.longitude = userDefaults.double(forKey: "longitude")
        currentLocation.utcOffset = Int64(userDefaults.double(forKey: "utcOffset"))
        return currentLocation
    }
}
