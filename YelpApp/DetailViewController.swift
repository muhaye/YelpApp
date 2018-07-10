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
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet var floatRatingView: FloatRatingView!

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dismiss: UIBarButtonItem!
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var address: UILabel!
    
    
    @IBOutlet weak var phone: UILabel!
    @IBAction func dismiss(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    
    func configureView() {
        
        /** Note: With the exception of contentMode, type and delegate,
         all properties can be set directly in Interface Builder **/
        // floatRatingView.delegate = self
        floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
        floatRatingView.type = .halfRatings
        floatRatingView.backgroundColor = UIColor.clear
        
        if let b = business {
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
    



}

