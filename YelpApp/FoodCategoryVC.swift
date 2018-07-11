//
//  FoodCategory.swift
//  YelpApp
//
//  Created by Ngendo Muhayimana on 2018-07-11.
//  Copyright © 2018 Ngendo Muhayimana. All rights reserved.
//

import UIKit
import CoreData

class FoodCategoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    
    var userDidSelectCuisine: ((_ selectedCuisine: String?) -> ())? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ApiManager().categories {
            self.spiner.stopAnimating()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let categoryCell = tableView.dequeueReusableCell(withIdentifier: "FoodCategoryCell" ) {
            categoryCell.textLabel?.text = foodCategory[ indexPath.row].title
            return categoryCell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        Session.shared.foodCategory = foodCategory[ indexPath.row]
        if let alias =  Session.shared.foodCategory?.alias {
            self.userDidSelectCuisine?( alias)
        }
                
        self.dismiss(animated: true) {
            
        }
    }
    
    var foodCategory: [Category] {
        
        let fetchRequest: NSFetchRequest<Category>  = Category.fetchRequest()
        
        //fetchRequest.predicate              = NSPredicate(format: " parent_aliases.alias CONTAINS[cd] 'food' " )
        let titleSortDescriptor             = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors        = [titleSortDescriptor]
        
        do{
            let res = try self.mContext.fetch(fetchRequest)
            
            return  res.filter ({
                if let parents = $0.parent_aliases?.allObjects as? [CategoryParents] {
                    
                    for parent in parents {
                        if parent.alias == "food" {
                            return true
                        }
                    }
                }

                return false
            })
            
        }catch{
            print("error \(error)")
        }
        
        return []
    }
    
    lazy var mContext : NSManagedObjectContext = {
        return DBUtils.sharedInstance.managedObjectContext
    }()
    
    @IBAction func cancel(_ sender: Any) {
        
        Session.shared.foodCategory = nil
        self.userDidSelectCuisine?( nil)
        self.dismiss(animated: true) {
            //
        }
        
    }
}
