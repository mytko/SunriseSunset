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
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat  = "YY-MM-dd"
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
            print(url)
            dispatchGroup.enter()
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                var info = try! JSONDecoder().decode(SunriseSunsetInfo.self, from: data!)
                info.date = dateFormatter.string(from: nextDate)
                sunInfo.append(info)
                print("\(index): \(info)")
                dispatchGroup.leave()
            }.resume()
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.completion(sunInfo)
        }
    }
}

struct SunriseSunsetInfo: Codable {
    public var results: Info
    public var date: String?
    
    struct Info: Codable {
        var sunrise: String
        var sunset: String
        var dayLength: String
        var twilightBegin: String
        var twilightEnd: String
        
        enum CodingKeys: String, CodingKey {
            case sunrise = "sunrise"
            case sunset = "sunset"
            case dayLength = "day_length"
            case twilightBegin = "civil_twilight_begin"
            case twilightEnd = "civil_twilight_end"
        }
    }
}
