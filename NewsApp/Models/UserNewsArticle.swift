//
//  UserNewsArticle.swift
//  NewsApp
//
//  Created by ITP312Grp2 on 29/6/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit

class UserNewsArticle: Codable {
    var username: String
    var title: String
    var content: String
    var date: String
    var imageName: String
    var lastUpdated: String
    
    init(_ username: String,_ title: String,_ content: String,_ date: String,_ imageName: String, lastUpdated: String){
        self.username = username
        self.title = title
        self.content = content
        self.date = date
        self.imageName = imageName
        self.lastUpdated = lastUpdated
    }
}
