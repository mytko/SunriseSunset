//
//  Place.swift
//  SunriseSunset
//
//  Created by Vasyl Mytko on 11/1/18.
//  Copyright © 2018 Vasyl Mytko. All rights reserved.
//

import Foundation

public struct PlaceData: Decodable {
    
    let predictions: [Place]
    
    struct Place: Decodable {
        let place_id: String
        let description: String
    }
}

public struct PlaceDetail: Decodable {
    var result: DetailResult
    struct DetailResult: Decodable {
        var geometry: Geometry
        var utcOffset: Int
        var description: String
        
        private enum CodingKeys: String, CodingKey {
            case geometry
            case utcOffset = "utc_offset"
            case description = "formatted_address"
        }
        
        struct Geometry: Decodable {
            var location: LocationCoordinates
            
            struct LocationCoordinates: Decodable {
                var lat: Double
                var lng: Double
            }
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
        var nauticalLightBegin: String
        var nauticalLightEnd: String
        var astroLightBegin: String
        var astroLightEnd: String
        var solarNoon: String
        
        enum CodingKeys: String, CodingKey {
            case sunrise
            case sunset
            case dayLength = "day_length"
            case twilightBegin = "civil_twilight_begin"
            case twilightEnd = "civil_twilight_end"
            case nauticalLightBegin = "nautical_twilight_begin"
            case nauticalLightEnd = "nautical_twilight_end"
            case astroLightBegin = "astronomical_twilight_begin"
            case astroLightEnd = "astronomical_twilight_end"
            case solarNoon = "solar_noon"
        }
    }
}
