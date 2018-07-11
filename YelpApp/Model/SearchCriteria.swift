//
//  SearchCriteria.swift
//  YelpApp
//
//  Created by Ngendo Muhayimana on 2018-07-09.
//  Copyright © 2018 Ngendo Muhayimana. All rights reserved.
//

import Foundation

enum SearchType: String {
    case name, address1, city, zip_code
    
    var storeKeyPath: String {
        switch self {
        case .name:
            return "name"
        case .address1:
            return "location.address1"
        case .city:
            return "location.city"
        case .zip_code:
            return "location.zip_code"
        }
    }
    
    var humanReadable: String {
        switch self {
        case .name:
            return " Name"
        case .address1:
            return " Address"
        case .city:
            return " City"
        case .zip_code:
            return "Postal code"
        }
    }
}

protocol SearchCriteriable {
    var name: SearchType { get }
    var checked: Bool { set get}
}

struct SearchCriteria: SearchCriteriable {
    let name: SearchType
    var checked = false
    init(name: SearchType, checked: Bool = false) {
        self.name = name
        self.checked = checked
    }
}
