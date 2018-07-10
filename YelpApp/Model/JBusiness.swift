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
    let display_address: String?
    //let categories: [JCategory]
}

extension Business {
    
    func  populate(with jBusinessc: JBusiness) {
        
        self.name                  = jBusinessc.name
        self.image_url             = jBusinessc.image_url
        self.display_address       = jBusinessc.display_address
    }
    
}

