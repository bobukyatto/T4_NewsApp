//
//  UserNewsArticle.swift
//  NewsApp
//
//  Created by ITP312Grp2 on 29/6/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit

class UserNewsArticle: NSObject {
    var username: String
    var title: String
    var content: String
    var date: Date
    
    init(username: String, title: String, content: String, date: Date){
        self.username = username
        self.title = title
        self.content = content
        self.date = date
    }
}
