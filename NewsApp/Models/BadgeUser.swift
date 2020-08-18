//
//  BadgeUser.swift
//  NewsApp
//
//  Created by ITP312Grp2 on 29/7/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit
import FirebaseFirestoreSwift

class BadgeUser: Codable {
    @DocumentID var id: String?;
    var badgeId: String;
    var uid: String;
    var current: Int;
    
    init(id: String? = UUID().uuidString, badgeId: String, uid: String, current: Int){
        self.id = id;
        self.badgeId = badgeId;
        self.uid = uid;
        self.current = current;
    }
}
