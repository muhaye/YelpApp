//
//  AdvanceSearchVC.swift
//  YelpApp
//
//  Created by Ngendo Muhayimana on 2018-07-09.
//  Copyright © 2018 Ngendo Muhayimana. All rights reserved.
//

import UIKit

class AdvanceSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchCriteria = AppDelegate().searchCriteria
    let check = UIImage(named:"check")
    let unchecked = UIImage(named:"unchecked")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchCriteria.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let advanceSearchCellell = tableView.dequeueReusableCell(withIdentifier: "AdvanceSearchCell" ) as? AdvanceSearchCell {
            advanceSearchCellell.textLabel?.text = searchCriteria[ indexPath.row].name.rawValue
            advanceSearchCellell.check.isHighlighted = searchCriteria[ indexPath.row].checked
            
            return advanceSearchCellell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        searchCriteria[ indexPath.row].checked = !searchCriteria[ indexPath.row].checked
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    
    }

}
