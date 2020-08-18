//
//  BadgeUserDataManager.swift
//  NewsApp
//
//  Created by Joel on 18/8/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class BadgeUserDataManager: NSObject {
    static let db = Firestore.firestore()
    private static let badgeUserRef = db.collection("userBadge")
    
    static func getUserBadge(user: User, badge: Badge, onComplete: ((BadgeUser?) -> Void)?) {
        badgeUserRef.whereField("uid", isEqualTo: user.uid!).whereField("badgeId", isEqualTo: badge.id!).getDocuments() {
            (snapshot, err) in
            
            var badge: BadgeUser?
            
            if let err = err {
                print("BadgeUserDataManager: \(err)")
            }
            else {
                badge = try? snapshot?.documents.first?.data(as: BadgeUser.self)
            }
            
            onComplete?(badge)
        }
    }
    
    static func insertUpdateUserBadge(user: User, badge: Badge) {
        self.getUserBadge(user: user, badge: badge, onComplete: {
            result in
            
            if (result == nil) {
                _ = try? badgeUserRef.addDocument(from: BadgeUser(badgeId: badge.id!, uid: user.uid!, current: 1))
            }
            else if result!.current < badge.max {
                _ = try? badgeUserRef.addDocument(from: BadgeUser(badgeId: result!.id!, uid: result!.uid, current: result!.current + 1))
            }
        })
    }
    
    static func updateFirstLoginBadge(user: User) {
        BadgeDataManager.getBadgeWithName(name: "First Login", onComplete: {
            result in
            
            if (result != nil) {
                self.insertUpdateUserBadge(user: user, badge: result!)
            }
        })
    }
}
