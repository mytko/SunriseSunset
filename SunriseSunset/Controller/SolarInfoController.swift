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

    var fetchedRC: NSFetchedResultsController<Location>!
    
    var selectedLocationIndex: Int = 0
    
    var selectedDate: Date!
    
    let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.currentPageIndicatorTintColor = .blue
        control.pageIndicatorTintColor = .lightGray
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchSolarData), name: NSNotification.Name("locationCalculated"), object: nil)
        toolBar.addSubview(pageControl)
        let request: NSFetchRequest<Location> = Location.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "x", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        fetchedRC = NSFetchedResultsController<Location>(fetchRequest: request, managedObjectContext: CoreDataStack.shared.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedRC.delegate = self
    }
    
    func refreshUI() {
        do {
            try fetchedRC.performFetch()
            pageControl.numberOfPages = fetchedRC.fetchedObjects?.count ?? 0
            locationcSolarInfoCollectionView.reloadData()
        } catch {
            fatalError()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("locationCalculated"), object: nil)
    }
    
    @objc func fetchSolarData() {
        refreshUI()
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = locationcSolarInfoCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
}

extension SolarInfoController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedRC.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "solarCell", for: indexPath) as! SolarInfoCell
        if let location = fetchedRC.fetchedObjects?[indexPath.item] {
            cell.location = location
        }
        return cell
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
