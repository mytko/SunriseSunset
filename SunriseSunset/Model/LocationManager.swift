//
//  LocationManager.swift
//  SunriseSunset
//
//  Created by Vasyl Mytko on 11/3/18.
//  Copyright © 2018 Vasyl Mytko. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

class LocationSunInfoManager: NSObject {
    
    let dispatchGroup = DispatchGroup()
    
    var completion: (Location) -> ()
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    private var location: Location!
    
    private var locationManager = CLLocationManager()
 
    init(completion: @escaping (Location) -> ()) {
        self.completion = completion
    }
    
    init(location: Location, completion: @escaping (Location) -> ()) {
        self.location = location
        self.completion = completion
    }
    
    init(latitude: Double, longitude: Double, completion: @escaping (Location) -> ()) {
        let entity = NSEntityDescription.entity(forEntityName: "Location", in: CoreDataStack.shared.managedContext)!
        
        location = Location(entity: entity,
                            insertInto: nil)
        location.latitude = latitude
        location.longitude = longitude
        self.completion = completion
    }
    
    private func configureManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestLocation()
        }
    }
    
    private func setLocationPlacemarks(_ placemark: CLPlacemark) {
        location.city = placemark.locality
        location.country = placemark.country
        location.administrativeArea = placemark.administrativeArea
    }
    
    public func updateSolarInfo() {
        location.solarInformation.forEach {
            CoreDataStack.shared.managedContext.delete($0)
        }
        
        setSolarInformation { _ in
            self.completion(self.location)
        }
    }
    
    func geocodeLocation(completion: @escaping (Location) -> ()) {
        let geocodingLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        CLGeocoder().reverseGeocodeLocation(geocodingLocation) { (placeMarks, error) in
            guard let placeNotations = placeMarks?[0] else {
                return
            }
            self.setLocationPlacemarks(placeNotations)
            completion(self.location)
        }
    }
    
    private func setSolarInformation(_ completion: @escaping ([SolarInfo]) -> ()) {
        let request = SunriseSunsetRequest(latitude: location.latitude, longtitude: location.longitude) { solarInformation in
            let result = solarInformation.map { info -> SolarInfo in
                let solarInfo = SolarInfo(context: CoreDataStack.shared.managedContext)
                solarInfo.location = self.location
                solarInfo.sunrise = info.results.sunrise
                solarInfo.sunset = info.results.sunset
                solarInfo.date = self.dateFormatter.date(from: info.date!) as NSDate?
                solarInfo.dayLength = info.results.dayLength
                solarInfo.twilightEnd = info.results.twilightEnd
                solarInfo.twilightBegin = info.results.twilightBegin
                return solarInfo
            }
            completion(result)
        }
        request.fetchSunInfoFrom(date: Date(), days: 7)
    }
    
    func getCurrentLocation() {
        configureManager()
    }
}

extension LocationSunInfoManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = manager.location else {
            return
        }
        
        location = Location(context: CoreDataStack.shared.managedContext)
        
        location.latitude = currentLocation.coordinate.latitude
        location.longitude = currentLocation.coordinate.longitude
        location.utcOffset = Int64(TimeZone.current.secondsFromGMT() / 60)
        
        //Setting Location placemarks
        dispatchGroup.enter()
        geocodeLocation {_ in
            self.dispatchGroup.leave()
        }
        
        //Setting SolarInformation
        dispatchGroup.enter()
        setSolarInformation { _ in
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.completion(self.location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}

