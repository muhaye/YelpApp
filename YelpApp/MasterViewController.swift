//
//  MasterViewController.swift
//  YelpApp
//
//  Created by Ngendo Muhayimana on 2018-07-09.
//  Copyright © 2018 Ngendo Muhayimana. All rights reserved.
//

import UIKit
import CoreData


class MasterViewController: UITableViewController,
    UIPopoverPresentationControllerDelegate,
    UISearchDisplayDelegate,
    UISearchBarDelegate,
    UISearchResultsUpdating,
    UISearchControllerDelegate,
    LocationUser {
    
    func notAuthorize() {

        let msg = "Location services are not enabled"
        let alert = UIAlertController(title: "Did you allow Location service?", message: msg , preferredStyle: .alert)
        self.present(alert, animated: true)
        print(msg);
    }
    
    func gotLocation(coordinate: (lat: Double, lon: Double)) {

//        ApiManager().search( coordinate: (coordinate.lat, coordinate.lon), completion:{
//
//        })
    }
    

    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    
    var resultsTableController: SResultsTableController?
    var searchController: UISearchController!

    var locationManager: LocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = LocationManager(user: self)
        
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        self.resultsTableController = self.storyboard!.instantiateViewController(withIdentifier: "SResultsTableController") as? SResultsTableController
        self.searchController = UISearchController(searchResultsController: self.resultsTableController)
        self.searchController!.searchResultsUpdater = self
        self.searchController!.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.searchController!.searchBar
        
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    @objc
//    func insertNewObject(_ sender: Any) {
//        let context = self.fetchedResultsController.managedObjectContext
//        let newEvent = Event(context: context)
//
//        // If appropriate, configure the new managed object.
//        newEvent.timestamp = Date()
//
//        // Save the context.
//        do {
//            try context.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nserror = error as NSError
//            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//        }
//    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
//            let object = fetchedResultsController.object(at: indexPath)
//                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
//                controller.detailItem = object
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        } else if segue.identifier == "showAdvanceSearch" {
            
            if let advanceSeachVC = segue.destination as? AdvanceSearchVC {
                advanceSeachVC.popoverPresentationController!.delegate = self
            }
        }
    }

    // MARK: - Table View


    // MARK: - Fetched results controller

//    var fetchedResultsController: NSFetchedResultsController<Event> {
//        if _fetchedResultsController != nil {
//            return _fetchedResultsController!
//        }
//
//        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
//
//        // Set the batch size to a suitable number.
//        fetchRequest.fetchBatchSize = 20
//
//        // Edit the sort key as appropriate.
//        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
//
//        fetchRequest.sortDescriptors = [sortDescriptor]
//
//        // Edit the section name key path and cache name if appropriate.
//        // nil for section name key path means "no sections".
//        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
//        aFetchedResultsController.delegate = self
//        _fetchedResultsController = aFetchedResultsController
//
//        do {
//            try _fetchedResultsController!.performFetch()
//        } catch {
//             // Replace this implementation with code to handle the error appropriately.
//             // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//             let nserror = error as NSError
//             fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//        }
//
//        return _fetchedResultsController!
//    }
//    var _fetchedResultsController: NSFetchedResultsController<Event>? = nil

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    /*  
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         tableView.reloadData()
     }
     */
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString: String = searchController.searchBar.text!
        self.resultsTableController!.searchedText = searchString
        self.tableView.reloadData()
    }
    
    @IBAction func updateSorting(_ sortor: UISegmentedControl) {
        
        Session.shared.sortCriteria = sortor.selectedSegmentIndex == 0 ? .distance : .rating
        
    }
}



