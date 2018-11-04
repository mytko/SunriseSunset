//
//  Place.swift
//  SunriseSunset
//
//  Created by Vasyl Mytko on 11/1/18.
//  Copyright © 2018 Vasyl Mytko. All rights reserved.
//

import Foundation

//struct Place {
//    var id: String
//    var description: String
//    
//    func fetchDetail(completion: @escaping (PlaceDetail.DetailResult) -> ()) {
//        var urlComponents = URLComponents()
//        urlComponents.scheme = "https"
//        urlComponents.host = "maps.googleapis.com"
//        urlComponents.path = "/maps/api/place/details/json"
//        urlComponents.queryItems = [
//            URLQueryItem(name: "placeid", value: id),
//            URLQueryItem(name: "key", value: "AIzaSyDKStABOvHicYu99-m-qa64dQcYeK8Y4tM")
//        ]
//       
//        URLSession.shared.dataTask(with: urlComponents.url!) { (data, response, error) in
//            print("Place detail \(try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments))".unescaped)
//            let location = try! JSONDecoder().decode(PlaceDetail.self, from: data!)
//            DispatchQueue.main.async {
//                completion(location.result)
//            }
//        }.resume()
//    }
//}


extension String {
    var unescaped: String {
        let entities = ["\0", "\t", "\n", "\r", "\"", "\'", "\\"]
        var current = self
        for entity in entities {
            let descriptionCharacters = entity.debugDescription.characters.dropFirst().dropLast()
            let description = String(descriptionCharacters)
            current = current.replacingOccurrences(of: description, with: entity)
        }
        return current
    }
}

struct PlaceData: Decodable {
    
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
