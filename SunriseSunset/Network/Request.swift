//
//  Request.swift
//  SunriseSunset
//
//  Created by Vasyl Mytko on 10/30/18.
//  Copyright © 2018 Vasyl Mytko. All rights reserved.
//

import Foundation

class SunriseSunsetRequest {
    
    public let latitude: Double
    public let longtitude: Double
    public let completion: ([SunriseSunsetInfo]) -> ()
    
    init(latitude: Double, longtitude: Double, completion: @escaping ([SunriseSunsetInfo]) -> ()) {
        self.latitude = latitude
        self.longtitude = longtitude
        self.completion = completion
    }
    
    func fetchSunInfoFrom(date: Date, days: Int) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.sunrise-sunset.org"
        urlComponents.path = "/json"
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lng", value: String(longtitude))
        ]
        
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat  = "yyyy-MM-dd"
        let calendar = Calendar.current
        
        let date = Date()
        
        let dispatchGroup = DispatchGroup()
        
        var sunInfo: [SunriseSunsetInfo] = []
        
        let _ = DispatchQueue.global(qos: .userInitiated)
        DispatchQueue.concurrentPerform(iterations: days) { index in
            var components = urlComponents
            let nextDate = calendar.date(byAdding: .day, value: index, to: date)!
            components.queryItems?.append(URLQueryItem(name: "date", value: dateFormatter.string(from: nextDate)))

            let url = components.url!
            dispatchGroup.enter()
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                var info = try! JSONDecoder().decode(SunriseSunsetInfo.self, from: data!)
                info.date = dateFormatter.string(from: nextDate)
                sunInfo.append(info)
                dispatchGroup.leave()
            }.resume()
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.completion(sunInfo)
        }
    }
    
    func fetchInfoForDate(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.sunrise-sunset.org"
        urlComponents.path = "/json"
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lng", value: String(longtitude)),
            URLQueryItem(name: "date", value: formatter.string(from: date))
        ]
        URLSession.shared.dataTask(with: urlComponents.url!) { (data, response, error) in
            DispatchQueue.main.async {
                var info = try! JSONDecoder().decode(SunriseSunsetInfo.self, from: data!)
                info.date = formatter.string(from: date)
                self.completion([info])
            }
        }.resume()
    }
}
