//
//  ApiManager.swift
//  YelpApp
//
//  Created by Ngendo Muhayimana on 2018-07-09.
//  Copyright © 2018 Ngendo Muhayimana. All rights reserved.
//

import Foundation
import Alamofire

public protocol WSItem {
    func json() -> [String:Any]
    func service() -> Service
}

public enum Service : String {
    case business    = "business"
}
