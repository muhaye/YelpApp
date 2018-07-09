//
//  SearchCriteria.swift
//  YelpApp
//
//  Created by Ngendo Muhayimana on 2018-07-09.
//  Copyright © 2018 Ngendo Muhayimana. All rights reserved.
//

import Foundation

enum SearchType: String {
    case name, address, city, postalCode
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
