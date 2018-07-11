    //
//  SResultsTableController.swift
//


import CoreData
import UIKit

class SResultsTableController: UIViewController,
    UITableViewDataSource,
UITableViewDelegate {
    
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var searchCriteriaChecked: [SearchCriteria] {
        return Session.shared.searchCriteria.filter({  $0.checked })
    }
    
    var userDidSelectTerm: ((_ selectedTerm: String) -> ())? = nil
    
    var searchedText: String?{
        didSet{
            func update() {
                self.result.text = "\(totalBusiness) results"
                self.tableView.reloadData()
            }
            
            update()
            
            if let searchedText = searchedText, searchedText.isEmpty == false {
                
                
                ApiManager().autocomplete(text: searchedText) { (terms: [JTerm]) in
                    self.terms = terms
                    
                    update()
                    
                    if self.searchCriteriaChecked.count > 0 {
                        
                        ApiManager().search(search: searchedText ) {
                            update()
                        }
                        
                    } else {
                        if let term = terms.first {
                            ApiManager().search(term: term.text) {
                                update()
                            }
                        }
                    }
                }
            }
        }
    }
    
    var selectedBusiness: Business?
    var terms: [JTerm] = []
    
    var totalBusiness: Int {
        
        if let sSearch = searchedText, sSearch.isEmpty == false {
            return self.businesss(searchString: sSearch).count
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? self.terms.count : totalBusiness
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let autocompliteCell         = tableView.dequeueReusableCell(withIdentifier: GlobalConstants.kAutocompliteCell),
            indexPath.section == 0 {
            autocompliteCell.textLabel?.text = self.terms[indexPath.row].text
            
            return autocompliteCell
            
        } else if let businessCell         = tableView.dequeueReusableCell(withIdentifier: GlobalConstants.kBusinessCell),
            indexPath.section == 1  {
            let business                = self.businesss(searchString: searchedText!)[indexPath.row]
            let titleTextPlain          = business.name! as NSString
            let texte                   = "\(business.detailOnliner )" as NSString
            
            let texteAttributed         = NSMutableAttributedString(string: business.detailOnliner , attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSCharacterEncodingDocumentAttribute: String.Encoding.utf8])
            let title                   = NSMutableAttributedString(string: titleTextPlain as String , attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15), NSCharacterEncodingDocumentAttribute: String.Encoding.utf8])
            var arrayOfSearchs = self.searchedText!.components(separatedBy: " ")
            arrayOfSearchs = arrayOfSearchs.filter({ $0.count > 0 })
            var textAttributedSniped : NSMutableAttributedString?
            let snipedCharMargin: Int = 20
            
            for cSearch in arrayOfSearchs {
                let wordRange: NSRange = texte.range(of: cSearch.lowercased(), options: NSString.CompareOptions.diacriticInsensitive)
                if textAttributedSniped == nil  && wordRange.location != NSNotFound {
                    var textSnipedRange: NSRange
                    if snipedCharMargin > wordRange.location {
                        textSnipedRange = NSMakeRange(0, snipedCharMargin * 2)
                    }
                    else {
                        textSnipedRange = NSMakeRange(wordRange.location - snipedCharMargin, snipedCharMargin * 2)
                    }
                    if textSnipedRange.location + textSnipedRange.length > texte.length - 1 {
                        textSnipedRange = NSMakeRange(texte.length - snipedCharMargin * 2, snipedCharMargin * 2)
                    }
                    var textSniped: NSString = texte.substring(with: textSnipedRange) as NSString
                    let firstSpaceRange: NSRange = textSniped.range(of: " ")
                    textSniped = textSniped.substring(with: NSMakeRange(firstSpaceRange.location, textSniped.length - firstSpaceRange.location)) as NSString
                    textSniped = "...\(textSniped)" as NSString
                    textAttributedSniped = NSMutableAttributedString(string: textSniped as String, attributes: [NSCharacterEncodingDocumentAttribute: String.Encoding.utf8])
                    textAttributedSniped!.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: textSniped.range(of: cSearch.lowercased(), options: NSString.CompareOptions.diacriticInsensitive))
                }
                title.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: titleTextPlain.range(of: cSearch.lowercased(), options: NSString.CompareOptions.diacriticInsensitive))
            }
            
            businessCell.textLabel?.attributedText = title
            businessCell.detailTextLabel?.attributedText = textAttributedSniped ?? texteAttributed
            
            return businessCell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let selectedTerm = self.terms[indexPath.row].text
            userDidSelectTerm?(selectedTerm)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentDetail" {
            if let indexPath = tableView.indexPathForSelectedRow,
                let detailVC = segue.destination as? DetailViewController {
                
                detailVC.business = self.businesss(searchString: searchedText!)[indexPath.row]
                
                //            let object = fetchedResultsController.object(at: indexPath)
                //                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                //                controller.detailItem = object
                //                detailVC.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                //                detailVC.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    func businesss(searchString: String) -> [Business] {
        let fetchRequest: NSFetchRequest<Business>  = Business.fetchRequest()
        let arrayOfSearchs                          = searchString.components(separatedBy: " ")
        
        if arrayOfSearchs.count == 0 {
            return []
        }
        
        var predicates: [NSPredicate] = []
        
        if searchCriteriaChecked.count > 0 {
            
            for searchCriteria in searchCriteriaChecked {
                
                if searchCriteria.name == .zip_code {
                    predicates.append(NSPredicate(format: " \(searchCriteria.name.storeKeyPath) CONTAINS[cd] '\(searchString.trimmingCharacters(in: .whitespaces))'  "))
                }
                
                predicates.append(NSPredicate(format: " \(searchCriteria.name.storeKeyPath) CONTAINS[cd] '\(searchString)'  "))
            }
            
        }else{
            
            if let currentTerm = self.terms.first?.text {
                let termPredicate = NSPredicate(format: "term.text CONTAINS[cd] '\(currentTerm)' " )
                predicates.append(termPredicate)
            }
        }
        
        
        fetchRequest.predicate          = NSCompoundPredicate(orPredicateWithSubpredicates:predicates)
        
        let distanceSortDescriptor      = NSSortDescriptor(key: "distance", ascending: true)
        let ratingSortDescriptor        = NSSortDescriptor(key: "rating", ascending: false)
        fetchRequest.sortDescriptors    = [Session.shared.sortCriteria == .distance ? distanceSortDescriptor : ratingSortDescriptor]
        
        do{
            return try self.mContext.fetch(fetchRequest)
        }catch{
            print("error \(error)")
        }
        
        return []
    }
    
    lazy var mContext : NSManagedObjectContext = {
        return DBUtils.sharedInstance.managedObjectContext
    }()
    
}
