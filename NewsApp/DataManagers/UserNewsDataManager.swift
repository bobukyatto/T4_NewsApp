//
//  UserNewsDataManager.swift
//  NewsApp
//
//  Created by Sharon on 21/7/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserNewsDataManager: NSObject {
    let db = Firestore.firestore()
    
    func addUserNews(_ article: UserNewsArticle){
        db.collection("userNews").document("placeholder").setData(
            [
                "username": article.username,
                "title": article.title,
                "content": article.content,
                "date": article.date,
                "imageName": article.imageName,
                "lastUpdated": article.lastUpdated
            ]
        )
        { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func deleteUserNews(_ newsId: String){
        db.collection("userNews").document("placeholder").delete()
        { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }

    
}
