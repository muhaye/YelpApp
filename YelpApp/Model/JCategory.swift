//
//  JCategory.swift
//  YelpApp
//
//  Created by Ngendo Muhayimana on 2018-07-09.
//  Copyright © 2018 Ngendo Muhayimana. All rights reserved.
//

import Foundation

struct JCategory: Codable {
    let title: String
    let alias: String
    let parent_aliases: [String]?
}

struct JCategoryRes: Codable {
    let categories: [JCategory]
}
