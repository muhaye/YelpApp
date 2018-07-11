//
//  ApiManager.swift
//  YelpApp
//
//  Created by Ngendo Muhayimana on 2018-07-09.
//  Copyright © 2018 Ngendo Muhayimana. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

public protocol WSItem {
    func json() -> [String:Any]
    func service() -> Service
}


public enum Service : String {
    case business           = "/businesses/search"
    case businessDetail     = "/businesses/{id}" // /{id}
    case autocomplete       = "/autocomplete"

}

open class ApiManager {
    
    let headers = [ "Authorization": "Bearer \(GlobalConstants.clientKey)" ]
    
    public init() {}

    
    func autocomplete(text: String, completion : @escaping (_ terms: [JTerm])-> Void) {
        
        let url = "\(GlobalConstants.api)\(Service.autocomplete.rawValue)"
        print("request \( url) ")
        
        guard let coordinate = Session.shared.coordinate else {
            completion([])
            return
        }
        
        let parameters: Parameters = [
            "latitude": "\(coordinate.lat)",
            "longitude": "\(coordinate.lon)",
            "text": text
        ]
        
        Alamofire.request(url,
                          method: .get,
                          parameters: parameters ,
                          encoding: URLEncoding.queryString,
                          headers: headers
        )
        .validate(statusCode: 200..<300)
        .response { (response) in

            if  let data = response.data {
            
                do {
                    print("response \(String(describing: String(data: data, encoding: .utf8)))")
                    
                    let jsonDecoder = JSONDecoder()
                    let jTermRes = try jsonDecoder.decode(JTermRes.self, from: data)
                    completion( jTermRes.terms)
                    
                } catch {
                    print("response \(error.localizedDescription)")
                    completion([])
                }
                
            } else {
                completion([])
            }
        }
    }
    
    func search(term: String, completion : @escaping ()-> Void) {
        
        let url = "\(GlobalConstants.api)\(Service.business.rawValue)"
        print("request \( url) ")
        
        guard let coordinate = Session.shared.coordinate else {
            completion()
            return
        }
        
        let parameters: Parameters = [
            "latitude": "\(coordinate.lat)",
            "longitude": "\(coordinate.lon)",
            "term":  term
        ]
        
        Alamofire.request(url,
                          method: .get,
                          parameters: parameters ,
                          encoding: URLEncoding.queryString,
                          headers: headers
            )
            .validate(statusCode: 200..<300)
            .response { (response) in
                
                if  let data = response.data {
                    do {
                        let jsonDecoder = JSONDecoder()
                        print("response \(String(describing: String(data: data, encoding: .utf8)))")

                        //jsonDecoder.dateDecodingStrategy = PublishDate.dateDecodingStrategy()
                        let jBusinessRes = try jsonDecoder.decode(JBusinessRes.self, from: data)
                        for jBusiness in jBusinessRes.businesses {
                            
                            if let business: Business = NSManagedObject.managedObjectUpsert(jBusiness.id) {
                                
                                business.populate(with: jBusiness)
                                
                                business.location = NSManagedObject.new()
                                business.location?.populate(with: jBusiness.location)
                                
                                if let categories = jBusiness.categories {
                                    business.categoires = []
                                    for jcat in categories {
                                        if let category: Category = NSManagedObject.new() {
                                            category.title = jcat.title
                                            business.addToCategoires(category)
                                        }
                                    }
                                }
                            }
                        }
                        
                        DBUtils.sharedInstance.saveContext()
                        
                    } catch {
                        
                        print("response \(error.localizedDescription)")
                        completion()
                    }
                    
                    completion()

                } else {
                    completion()
                }
        }
    }
    
    open func business(id: String, completion : @escaping ()-> Void) {
        
        let url = "\(GlobalConstants.api)\( Service.businessDetail.rawValue.replacingOccurrences(of: "{id}", with: id)  )"
        print("request \( url) ")
        
        Alamofire.request(url,
                          method: .get,
                          encoding: URLEncoding.queryString,
                          headers: headers
            )
            .validate(statusCode: 200..<300)
            .response { (response) in
                
                if  let data = response.data {
                    do {
                        let jsonDecoder = JSONDecoder()
                        print("response \(String(describing: String(data: data, encoding: .utf8)))")
                        
                        let jBusiness = try jsonDecoder.decode(JBusiness.self, from: data)
                        
                        if let business: Business = NSManagedObject.managedObjectUpsert(jBusiness.id) {
                            
                            if let hours = jBusiness.hours {
                                
                                for jhour in hours {
                                    
                                    if let hour = NSManagedObject.managedObjectUpsert(jhour.hours_type, business: business) {
                                        
                                        hour.open = [] // clear preview data
                                        for jopen in jhour.open {
                                            if let open: Open = NSManagedObject.new() {
                                                open.day            = Int32(jopen.day)
                                                open.start          = jopen.start
                                                open.end            = jopen.end
                                                //open.is_overnight   = jopen.is_overnight
                                                hour.addToOpen(open)
                                            }
                                        }
                                    }
                                    
                                }
                            }
                        }
                        
                        
                        DBUtils.sharedInstance.saveContext()
                        
                        //completion(publishDate)
                    } catch {
                        
                        print("response \(error.localizedDescription)")
                        completion()
                    }
                    
                    completion()
                    
                } else {
                    completion()
                }
        }
    }
    
    
    
}

