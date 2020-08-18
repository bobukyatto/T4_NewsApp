//
//  BadgeDataManager.swift
//  NewsApp
//
//  Created by Joel on 18/8/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class BadgeDataManager: NSObject {
    static let db = Firestore.firestore()
    private static let badgeRef = db.collection("badges")
    
    static func getBadges(onComplete: (([Badge]) -> Void)?) {
        badgeRef.getDocuments() {
            (snapshot, err) in
            
            var badges: [Badge] = []
            
            if let err = err {
                print("BadgeDatamanager: \(err)")
            }
            else {
                if snapshot!.documents.count > 0 {
                    for doc in snapshot!.documents {
                        let item = try? doc.data(as: Badge.self)!
                        
                        if item != nil {
                            badges.append(item!)
                        }
                    }
                }
                else {
                    self.insertUpdateBadge(badge: Badge(name: "10 Post", category: "Community", description: "You have made your tenth post!", max: 10))
                    self.insertUpdateBadge(badge: Badge(name: "First Post", category: "Community", description: "You have made your first post!", max: 1))
                    self.insertUpdateBadge(badge: Badge(name: "Reader", category: "News", description: "You have read your first official news!", max: 1))
                    self.insertUpdateBadge(badge: Badge(name: "First Login", category: "General", description: "You have logged in to your account for the first time!", max: 1))
                }
            }
            
            onComplete?(badges)
        }
    }
    
    static func getBadgeWithName(name: String, onComplete: ((Badge?) -> Void)?) {
        badgeRef.whereField("name", isEqualTo: name).getDocuments() {
            (snapshot, err) in
            
            var badge: Badge?
            
            if let err = err {
                print("BadgeDataManager: \(err)")
            }
            else {
                if (snapshot?.documents.count)! > 0 {
                    badge = try? snapshot?.documents.first?.data(as: Badge.self)
                }
            }
            
            onComplete?(badge)
        }
    }
    
    private static func insertUpdateBadge(badge: Badge) {
        try? badgeRef.document().setData(from: badge) {
            err in
            
            if let err = err {
                print("BadgeDatamanager: \(err)")
            }
            else {
                print("BadgeDatamanager: Add successful!")
            }
        }
    }
}
