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
    case business    = "/search"
}

open class ApiManager {
    
    public init() {}
    
    //open func search(completion : @escaping (_ changes: PublishDate?)-> Void) {

    let headers = [ "Authorization": "Bearer \(GlobalConstants.clientKey)" ]

    open func search(coordinate: (lat: Double, lon: Double), completion : @escaping ()-> Void) {
        
        let url = "\(GlobalConstants.api)\(Service.business.rawValue)"
        print("request \( url) ")
        
        let parameters: Parameters = [
            "latitude": "\(coordinate.lat)",
            "longitude": "\(coordinate.lon)"
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
                                
                                _ = business.populate(with: jBusiness)
                            }
                            
                        }
                        
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

