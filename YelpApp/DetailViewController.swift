//
//  DetailViewController.swift
//  YelpApp
//
//  Created by Ngendo Muhayimana on 2018-07-09.
//  Copyright © 2018 Ngendo Muhayimana. All rights reserved.
//

import UIKit
import FloatRatingView

class DetailViewController: UIViewController {

    var business: Business?
    let weekDay = ["Sunday", "Monday", "Tuesday", "Wendsday", "Thurstday", "Friday", "Saturday"]
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet var floatRatingView: FloatRatingView!

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dismiss: UIBarButtonItem!
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var hours: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var categories: UILabel!
    
    func configureView() {
        

        /** Note: With the exception of contentMode, type and delegate,
         all properties can be set directly in Interface Builder **/
        // floatRatingView.delegate = self
        floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
        floatRatingView.type = .halfRatings
        floatRatingView.backgroundColor = UIColor.clear
        
        
        if let b = business {
            
            ApiManager().business(id: b.objectId!) {
                self.activityIndicator.stopAnimating()
                
                // Add hours
                if let hours = b.hours?.allObjects as? [Hour] {
                    var hrs = ""
                    for hour in hours {
                        
                        if let hour = hour.open?.allObjects as? [Open] {
                            
                            for open in hour.sorted(by: { (l, r) -> Bool in
                                l.day < r.day
                            }) {
                                if var start: String = open.start,
                                    var end: String = open.end {
                                    
                                    if hrs.isEmpty { hrs = "Hours of operation\n" }
                                    
                                    start.insert("h", at:  start.index( start.startIndex, offsetBy: 2))
                                    end.insert("h", at:   end.index( end.startIndex, offsetBy: 2) )
                                    
                                    hrs += "\t\( self.weekDay[Int(open.day)]) "
                                    hrs += "\(start) -> \(end) \n"
                                }
                            }
                        }
   
                    }
                    self.hours.text = hrs
                }
                
                // Add Categories
                if let categories = b.categoires?.allObjects as? [Category] {
                    var cgs = ""
                    var sep = ""
                    for category in categories {
                        if cgs.isEmpty { cgs = "Categories\n" }
                        cgs += " \(sep) \(category.title ??  "" )"
                        sep = "-"
                    }
                    self.categories.text = cgs
                }
            }
            
            self.floatRatingView.rating = b.rating
            self.name.text              = b.name
            self.address.text           = b.location?.display_address
            self.phone.text             = b.display_phone
            
            if  let imageStr =  b.image_url,
                let imgUrl = URL(string: imageStr) {
                loadImage(url: imgUrl)
            }
        }
        
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.name
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Business? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    
    func loadImage(url: URL ) {
        
        URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
            
            //if there is any error
            if let e = error {
                //displaying the message
                print("Error Occurred: \(e)")
                
            } else {
                //in case of now error, checking wheather the response is nil or not
                if (response as? HTTPURLResponse) != nil {
                    
                    //checking if the response contains an image
                    if let imageData = data {
                        
                        //getting the image
                        
                        DispatchQueue.main.async {
                            let image = UIImage(data: imageData)
                            //displaying the image
                            self.photo.image = image
                        }
                                                
                    } else {
                        print("Image file is currupted")
                    }
                } else {
                    print("No response from server")
                }
            }
        }.resume()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
}



