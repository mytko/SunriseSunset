//
//  SearchLocationController.swift
//  SunriseSunset
//
//  Created by Vasyl Mytko on 10/31/18.
//  Copyright © 2018 Vasyl Mytko. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class SearchLocationController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var suggestionTableView: UITableView!
    @IBOutlet weak var suggestionTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var locationStackView: UIStackView!
    
    @IBAction func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: mapView)
        
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = coordinate
        
        mapView.removeAnnotations(mapView.annotations)
        
        mapView.addAnnotation(annotation)
        
        locationManager = LocationSunInfoManager(latitude: coordinate.latitude, longitude: coordinate.longitude) { location in
            location.saveLocation()
            self.dismiss(animated: true, completion: nil)
        }
        
        locationManager.geocodeLocation { location in
            self.locationLabel.text = "\(location.city!), \(location.country!)"
            self.locationStackView.isHidden = false
            self.containerView.isHidden = false
        }
    }
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var locationManager: LocationSunInfoManager!
    
    var placeRequest: PlaceAutocompleteRequest!
    
    var possiblePlaces: [PlaceData.Place] = []
    
    var previouslySearched = ""
    
    var enteredLocation: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeRequest = PlaceAutocompleteRequest(delegate: self)
        setupAddLocationButton()
        setupSearchController()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search city"
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func setupAddLocationButton() {
        addLocationButton.addTarget(self, action: #selector(addLocation(_:)), for: .touchUpInside)
    }
    
    @objc func addLocation(_ sender: UIButton) {
        locationManager.updateSolarInfo()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        containerView.layer.cornerRadius = 15
        addLocationButton.layer.cornerRadius = 10
    }
}

extension SearchLocationController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return possiblePlaces.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LocationAutocompleteCell
        cell.locationDescriptionLabel.text = possiblePlaces[indexPath.row].description
        return cell
    }
}

extension SearchLocationController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            self.suggestionTableViewHeightConstraint.constant = 0
            self.addLocationButton.isHidden = false
        }
        searchController.searchBar.resignFirstResponder()
        placeRequest.fetchPlaceDetailInformation(for: possiblePlaces[indexPath.item].place_id)
    }
}

extension SearchLocationController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: placeRequest, selector: #selector(placeRequest.getAutocompleteFor(description:)), object: previouslySearched)
        
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            return
        }
        previouslySearched = enteredLocation
        placeRequest.perform(#selector(placeRequest.getAutocompleteFor(description:)), with: enteredLocation, afterDelay: 1)
    }
}

extension SearchLocationController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        UIView.animate(withDuration: 0.5, animations: {
            self.suggestionTableViewHeightConstraint.constant = self.view.frame.height
        })
        enteredLocation = searchText
        NSObject.cancelPreviousPerformRequests(withTarget: placeRequest, selector: #selector(placeRequest.getAutocompleteFor(description:)), object: previouslySearched)
        
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            return
        }
        previouslySearched = enteredLocation
        placeRequest.perform(#selector(placeRequest.getAutocompleteFor(description:)), with: enteredLocation, afterDelay: 1)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.5, animations: {
            self.suggestionTableViewHeightConstraint.constant = 0
        })
    }
}

extension SearchLocationController: PlaceAutocompleteRequestDelegate {
    func placeDetail(_ location: Location) {
        let regionRadius: CLLocationDistance = 10000
        let coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        locationLabel.text = (location.city ?? "") + (location.country ?? "")
        locationStackView.isHidden = false
        containerView.isHidden = false
        
        locationManager = LocationSunInfoManager(location: location) { calculatedLocation in
            calculatedLocation.saveLocation()
            self.dismiss(animated: true, completion: nil)
        }

        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        self.mapView.setCenter(coordinateRegion.center, animated: true)
    }
    
    func placesResult(_ places: [PlaceData.Place]) {
        possiblePlaces = places
        suggestionTableView.reloadData()
    }
}
