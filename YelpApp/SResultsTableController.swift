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
    
    var searchedText: String?{
        didSet{
            func update() {
                self.result.text = "\(total) results"
                self.tableView.reloadData()
            }
            
            update()
            
            ApiManager().search {
                self.tableView.reloadData()
                update()
            }
            
        }
    }
    
    var selectedBusiness: Business?
    
    
    var total: Int {
        
        if let sSearch = searchedText, sSearch.isEmpty == false {
            return self.businesss(searchString: sSearch).count
        } else {
            return 0
        }    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return total
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let titleCell               = tableView.dequeueReusableCell(withIdentifier: GlobalConstants.kBusinessCell)
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
        titleCell!.textLabel!.attributedText = title
        titleCell!.detailTextLabel!.attributedText = textAttributedSniped ?? texteAttributed
        titleCell!.backgroundColor = UIColor(red: 230 / 255.0, green: 231 / 255.0, blue: 232 / 255.0, alpha: 1.0)
        titleCell!.textLabel!.font = UIFont.boldSystemFont(ofSize: 15)
        titleCell!.detailTextLabel!.numberOfLines = 2
        titleCell!.detailTextLabel!.font = UIFont.systemFont(ofSize: 14)
        return titleCell!
    }

//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 75.0
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.selectedBusiness    = self.businesss(searchString: searchedText!)[indexPath.row]
//        let detailVC             = self.presentingViewController as! TitreListVC
//        titreListVC.selectedBusiness = self.selectedBusiness
//        titreListVC.performSegue(withIdentifier: ShowSegue.Business.rawValue, sender: self)
//    }
    
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
        
        let predicates = arrayOfSearchs.filter({ $0.count > 0 }).map( {
           // return NSPredicate(format: " (numero CONTAINS[cd] %@ OR texte CONTAINS[cd] %@)", $0.lowercased(), $0.lowercased())
            return NSPredicate(format: "name CONTAINS[cd] %@", $0.lowercased() )

        } )
        
        fetchRequest.predicate          = NSCompoundPredicate(andPredicateWithSubpredicates:predicates)
        let distanceSortDescriptor      = NSSortDescriptor(key: "distance", ascending: true)
        let ratingSortDescriptor        = NSSortDescriptor(key: "rating", ascending: false)

        fetchRequest.sortDescriptors    = [distanceSortDescriptor, ratingSortDescriptor]
        
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
