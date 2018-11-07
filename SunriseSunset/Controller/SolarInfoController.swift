//
//  SolarInfoController.swift
//  SunriseSunset
//
//  Created by Vasyl Mytko on 10/29/18.
//  Copyright © 2018 Vasyl Mytko. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class SolarInfoController: UIViewController {

    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var locationcSolarInfoCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var locationManager: LocationSunInfoManager!
    
    var fetchedRC: NSFetchedResultsController<Location>!
    
    var selectedDate = Date()
    
    var selectedLocation: Location?
    
    let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.currentPageIndicatorTintColor = .white
        control.pageIndicatorTintColor = .darkGray
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchSolarData), name: NSNotification.Name("locationCalculated"), object: nil)
        toolBar.addSubview(pageControl)
        
        setupFetchedResultsController()
        refreshUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("locationCalculated"), object: nil)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: toolBar.centerXAnchor),
            pageControl.centerYAnchor.constraint(equalTo: toolBar.centerYAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let location = selectedLocation {
            locationcSolarInfoCollectionView.scrollToItem(at: indexPathOfLocation(location), at: .right, animated: false)
            activityIndicator.stopAnimating()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = locationcSolarInfoCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "datePickerController", let datePickerController = segue.destination as? DatePickerController {
            datePickerController.delegate = self
        }
    }
    
    func indexPathOfLocation(_ location: Location) -> IndexPath {
        let item = fetchedRC.fetchedObjects?.firstIndex { $0.city == location.city }
        return IndexPath(item: item!, section: 0)
    }
    
    func refreshUI() {
        do {
            activityIndicator.startAnimating()
            try fetchedRC.performFetch()
            if !(fetchedRC.fetchedObjects?.first?.solarInformation.isEmpty ?? true) {
                pageControl.numberOfPages = fetchedRC.fetchedObjects?.count ?? 0
                locationcSolarInfoCollectionView.reloadData()
            } else {
                return
            }
            activityIndicator.stopAnimating()
        } catch {
            fatalError()
        }
    }
    
    func setupFetchedResultsController() {
        let request: NSFetchRequest<Location> = Location.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "city", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        fetchedRC = NSFetchedResultsController<Location>(fetchRequest: request, managedObjectContext: CoreDataStack.shared.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedRC.delegate = self
    }
    
    @objc func fetchSolarData() {
        activityIndicator.stopAnimating()
        refreshUI()
    }
}

extension SolarInfoController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedRC.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "solarCell", for: indexPath) as! SolarInfoCell
        if let location = fetchedRC.fetchedObjects?[indexPath.item] {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            let calendar = Calendar.current
            let startDate = Date(timeInterval: -300, since: Date())
            let endDate = calendar.date(byAdding: .day, value: 7, to: startDate)!
            let interval = DateInterval(start: startDate, end: endDate)
            
            let solarInfo: SolarInfo
            
            if interval.contains(selectedDate) {
                solarInfo = location.solarInformation.filter { formatter.string(from: $0.date! as Date) == formatter.string(from: selectedDate) }.first!
                cell.updateCell(location: location, solarInfo: solarInfo)
                activityIndicator.stopAnimating()
            } else {
                let request = SunriseSunsetRequest(latitude: location.latitude, longtitude: location.longitude) { sunInfo in
                    let solarInfo = SolarInfo.initWith(info: sunInfo.first!)
                    cell.updateCell(location: location, solarInfo: solarInfo)
                    self.activityIndicator.stopAnimating()
                }
                request.fetchInfoForDate(selectedDate)
            }
        }
        return cell
    }
}

extension SolarInfoController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.item
    }
}

extension SolarInfoController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension SolarInfoController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        refreshUI()
    }
}

extension SolarInfoController: DatePickerDelegate {
    func datePicker(_ datePicker: UIDatePicker, didChangeDate date: Date) {
        selectedDate = date
        activityIndicator.startAnimating()
        locationcSolarInfoCollectionView.reloadData()
    }
}

