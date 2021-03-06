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

struct JBusiness: Codable {
    let id: String
    let name: String
    let image_url: String
    let location: JLocation
    let rating: Double
    let display_phone: String
    let hours: [JHour]?
    let categories: [JCategory]?
}

struct JHour: Codable {
    let hours_type: String
    let open: [JOpen]
}

struct JOpen: Codable {
    let day: Int
    let start: String
    let end: String
    //let is_overnight: Bool
}

struct JLocation: Codable {
    let address1: String
    let city: String
    let zip_code: String
    let display_address: [String]
}

struct JTermRes: Codable {
    let terms: [JTerm]
}

struct JTerm: Codable {
    let text: String
}

extension Location {
    
    func populate(with jLocation: JLocation) {
        self.address1           = jLocation.address1
        self.city               = jLocation.city
        self.zip_code           = jLocation.zip_code.trimmingCharacters(in: .whitespaces)
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

