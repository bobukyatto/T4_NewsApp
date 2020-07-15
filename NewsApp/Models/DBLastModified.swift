//
//  DBLastModified.swift
//  NewsApp
//
//  Created by Joel on 14/7/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit

class DBLastModified: Codable {
    var table: String
    var lastModified: Date
    
    init(table: String, lastModified: Date) {
        self.table = table
        self.lastModified = lastModified
    }
}
