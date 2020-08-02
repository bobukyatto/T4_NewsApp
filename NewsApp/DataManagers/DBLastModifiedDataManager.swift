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
    let db = Firestore.firestore()
    
    func getLastModified(onComplete: (([DBLastModified]) -> Void)?) {
        db.collection("lastModified").getDocuments() {
            (snapshot, err) in
            
            var dbLastModifiedList: [DBLastModified] = []
            
            if let err = err {
                print("DBLastModifiedDataManager: \(err)")
            }
            else {
                for document in snapshot!.documents {
                    let item = try? document.data(as: DBLastModified.self)!
                    
                    if item != nil {
                        dbLastModifiedList.append(item!)
                    }
                }
            }
            
            onComplete?(dbLastModifiedList)
        }
    }
    
    func insertReplaceLastModified(_ dbLastModified: DBLastModified) {
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
    
    func deleteLastModified(_ dbLastModified: DBLastModified) {
        db.collection("lastModified").document(dbLastModified.table).delete()
    }
}
