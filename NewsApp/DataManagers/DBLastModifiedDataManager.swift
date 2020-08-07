//
//  DBLastModifiedDataManager.swift
//  NewsApp
//
//  Created by Joel on 14/7/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class DBLastModifiedDataManager: NSObject {
    static let db = Firestore.firestore()
    
    static func getLastModified(tableName: String, onComplete: ((DBLastModified?) -> Void)?) {
        db.collection("lastModified").whereField("table", isEqualTo: tableName).getDocuments() {
            (snapshot, err) in
            
            var lastModified: DBLastModified?
            
            if let err = err {
                print("DBLastModifiedDataManager: \(err)")
            }
            else {
                lastModified = try? snapshot?.documents.first?.data(as: DBLastModified.self)
            }
            
            onComplete?(lastModified)
        }
    }
    
    static func insertReplaceLastModified(_ dbLastModified: DBLastModified) {
        try? db.collection("lastModified").document(dbLastModified.table).setData(from: dbLastModified, encoder: Firestore.Encoder()) {
            err in
            
            if let err = err {
                print("DBLastModifiedDataManager: \(err)")
            }
            else {
                print("DBLastModifiedDataManager: Updated successful!")
            }
        }
    }
    
    static func deleteLastModified(_ dbLastModified: DBLastModified) {
        db.collection("lastModified").document(dbLastModified.table).delete()
    }
}
