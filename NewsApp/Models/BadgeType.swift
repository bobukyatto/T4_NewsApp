//
//  BadgeType.swift
//  NewsApp
//
//  Created by ITP312Grp2 on 29/7/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit

class BadgeType: NSObject {
    var badgeID = ""
    var badgeCategoryName:String = ""
    var badgeTitle:String = ""
    var badgeDescription:String = ""
    var badgeImage: String = ""
    var badgeProgressionMax: Int
    var badgeProgressionCurrent: Int = 0
    
    init(ID:String,Category:String, Title:String, Description:String, Image:String, ProgressionMax:Int ){
        self.badgeID = ID
        self.badgeCategoryName = Category
        self.badgeTitle = Title
        self.badgeDescription = Description
        self.badgeImage = Image
        self.badgeProgressionMax = ProgressionMax
        
    }
}
