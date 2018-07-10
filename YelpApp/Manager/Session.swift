//
//  Session.swift
//  YelpApp
//
//  Created by Ngendo Muhayimana on 2018-07-09.
//  Copyright © 2018 Ngendo Muhayimana. All rights reserved.
//

import Foundation

class Session {
    static let shared = Session()
    private init() {}
    
    var searchCriteria = [SearchCriteria(name: .name, checked: true),
                               SearchCriteria(name: .address),
                               SearchCriteria(name: .city),
                               SearchCriteria(name: .postalCode)]
    
    var coordinate: (lat: Double, lon: Double)?
}
