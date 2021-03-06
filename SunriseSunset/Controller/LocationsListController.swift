//
//  LocationsListController.swift
//  SunriseSunset
//
//  Created by Vasyl Mytko on 10/30/18.
//  Copyright © 2018 Vasyl Mytko. All rights reserved.
//

import UIKit
import CoreData

class LocationsListController: UIViewController {
    
    @IBOutlet weak var locationsTableView: UITableView!
    
    var fetchedResultsController: NSFetchedResultsController<Location>?
    
    let coreDataStack = CoreDataStack.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let request: NSFetchRequest<Location> = Location.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "city", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataStack.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        refreshUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUI()
    }
    
    private func refreshUI() {
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            fatalError("Fatal error occured while fetching locations")
        }
        
        locationsTableView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "solarInfo" {
            if let destination = segue.destination as? SolarInfoController, let cell = sender as? UITableViewCell {
                destination.selectedLocation = fetchedResultsController?.fetchedObjects?[locationsTableView.indexPath(for: cell)!.section]
            }
        }
    }

}

extension LocationsListController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LocationCell
        cell.setupCell(location: (fetchedResultsController?.fetchedObjects?[indexPath.section])!)
        return cell
    }
}

extension LocationsListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .clear
        return footer
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let userDefaults = UserDefaults.standard
        if Location.currentLocationFrom(userDefaults: userDefaults)!.city == fetchedResultsController?.fetchedObjects![indexPath.section].city {
            return
        }
        if editingStyle == .delete {
            fetchedResultsController?.fetchedObjects?[indexPath.section].delete()
            do {
                try fetchedResultsController?.performFetch()
            } catch {
                fatalError()
            }
            tableView.beginUpdates()
            tableView.deleteSections([indexPath.section], with: .automatic)
            tableView.endUpdates()
        }
    }
}





