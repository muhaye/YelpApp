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
    
    var searchCriteria = [SearchCriteria(name: .name),
                               SearchCriteria(name: .address1),
                               SearchCriteria(name: .city),
                               SearchCriteria(name: .zip_code)]
    
    var sortCriteria: SortCriteria = .distance
    var foodCategory: Category?
    var coordinate: (lat: Double, lon: Double)? = (45.512337, -73.552768) // Default value
}
