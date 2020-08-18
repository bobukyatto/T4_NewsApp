//
//  Badge.swift
//  NewsApp
//
//  Created by 145532G  on 7/18/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit
import FirebaseFirestoreSwift

class Badge: Codable {
    @DocumentID var id: String?;
    var name: String;
    var category: String;
    var description: String;
    var max: Int;
    
    init(id: String? = UUID().uuidString, name:String, category: String, description: String, max:Int){
        self.id = id;
        self.name = name
        self.category = category;
        self.description = description;
        self.max = max
    }
}
