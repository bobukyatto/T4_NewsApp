//
//  Badge.swift
//  NewsApp
//
//  Created by 145532G  on 7/18/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit

class Badge: NSObject {
    //For main badge category page
    
    var badgeCategoryID:String
    var badgeCategoryName:String
    var badgeCategoryImage:String
    var badgeCategoryProgressionCurrent: Int
    var badgeCategoryProgressionMax: Int
    
    init(ID:String,Name:String, Image:String, ProgressionCurrent:Int, ProgressionMax:Int ){
        self.badgeCategoryID = ID
        self.badgeCategoryName = Name
        self.badgeCategoryImage = Image
        self.badgeCategoryProgressionCurrent = ProgressionCurrent
        self.badgeCategoryProgressionMax = ProgressionMax
        
    }

}
