//
//  JBusiness.swift
//  YelpApp
//
//  Created by Ngendo Muhayimana on 2018-07-09.
//  Copyright © 2018 Ngendo Muhayimana. All rights reserved.
//


import Foundation

struct JBusinessRes: Codable {
    let businesses: [JBusiness]
}

struct JBusiness : Codable {
    let id: String
    let name: String
    let image_url: String
    let location: JLocation
    let rating: Double
    let display_phone: String

    //let categories: [JCategory]
}

struct JLocation: Codable {
    let address1: String
    let city: String
    let zip_code: String
    let display_address: [String]
    
    
    
}

extension Location {
    
    func populate(with jLocation: JLocation) {
        self.address1           = jLocation.address1
        self.city               = jLocation.city
        self.zip_code           = jLocation.zip_code
        self.display_address    = jLocation.display_address.joined(separator: "\n")
    }
}

extension Business {
    
    // convenience
    
    var detailOnliner: String {
        return self.location?.display_address?.replacingOccurrences(of: "\n", with: ", ") ?? ""
    }
    
    func  populate(with jBusiness: JBusiness) {
        self.objectId              = jBusiness.id
        self.name                  = jBusiness.name
        self.image_url             = jBusiness.image_url
        self.rating                = jBusiness.rating
        self.display_phone         = jBusiness.display_phone
        //print("jBusiness \(jBusiness.location.display_address )" )
    }
    
}

