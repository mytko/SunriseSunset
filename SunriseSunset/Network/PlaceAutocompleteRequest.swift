//
//  PlaceSearchRequest.swift
//  SunriseSunset
//
//  Created by Vasyl Mytko on 11/1/18.
//  Copyright © 2018 Vasyl Mytko. All rights reserved.
//

import Foundation

class PlaceAutocompleteRequest: NSObject {

    public weak var delegate: PlaceAutocompleteRequestDelegate?
    
    init(delegate: PlaceAutocompleteRequestDelegate) {
        self.delegate = delegate
    }
    
    @objc public func getAutocompleteFor(description: String) {
        let url = buildURLWith(description: description)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                print(try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments))
                let places = try! JSONDecoder().decode(PlaceData.self, from: data!)
                self.delegate?.placesResult(places.predictions)
            }
        }.resume()
    }
    
    func fetchPlaceDetailInformation(for id: String) {
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
            let url = URL(string: path),
            let dict = NSDictionary(contentsOf: url),
            let key = dict["key"] as? String else {
            return
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "maps.googleapis.com"
        urlComponents.path = "/maps/api/place/details/json"
        urlComponents.queryItems = [
            URLQueryItem(name: "placeid", value: id),
            URLQueryItem(name: "key", value: key)
        ]
        
        URLSession.shared.dataTask(with: urlComponents.url!) { (data, response, error) in
            let placeDetail = try! JSONDecoder().decode(PlaceDetail.self, from: data!)
            let location = Location.initWith(placeDetail: placeDetail)
            DispatchQueue.main.async {
                self.delegate?.placeDetail(location)
            }
        }.resume()
    }
    
    private func buildURLWith(description: String) -> URL {
        var urlComponetns = URLComponents()
        urlComponetns.scheme = "https"
        urlComponetns.host = "maps.googleapis.com"
        urlComponetns.path = "/maps/api/place/autocomplete/json"
        urlComponetns.queryItems = [
            URLQueryItem(name: "key", value: "AIzaSyDKStABOvHicYu99-m-qa64dQcYeK8Y4tM"),
            URLQueryItem(name: "input", value: description),
            URLQueryItem(name: "types", value: "\(PlaceType.geocode.description)")
        ]
        return urlComponetns.url!
    }
}

protocol PlaceAutocompleteRequestDelegate: class {
    func placeDetail(_ location: Location)
    func placesResult(_ places: [PlaceData.Place])
}

enum PlaceType: CustomStringConvertible {
    case all
    case cities
    case region
    case geocode
    
    var description: String {
        switch self {
        case .all: return ""
        case .cities: return "(cities)"
        case .region: return "regions"
        case .geocode: return "geocode"
        }
    }
}
