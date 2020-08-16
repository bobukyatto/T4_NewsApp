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

class UserNewsDataManager {
    static var db = Firestore.firestore()
    
    
    static func loadUserNews(onComplete: (([UserNewsArticle]) -> Void)?){
        db.collection("userNews").getDocuments(){
            (querySnapshot, err) in
            var newsList: [UserNewsArticle] = []
            if let err = err{
                print("Error getting documents: \(err)")
            }
            else{
                for document in querySnapshot!.documents{
                    var usernews = try? document.data(as: UserNewsArticle.self) as! UserNewsArticle
                    
                    if usernews != nil{
                        newsList.append(usernews!)
                    }
                }
            }
            onComplete?(newsList)
        }
    }
    
    static func getNoOfNews() -> Int{
        var newsList2: [UserNewsArticle] = []
        self.loadUserNews(){
            newsListFromFireStore in
            newsList2 = newsListFromFireStore
        }
        return newsList2.count
    }
    
    static func addUserNews(_ article: UserNewsArticle, _ postId: Int){
       
        db.collection("userNews").document().setData(
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
    
    static func updateUserNews (_ article: UserNewsArticle){
        db.collection("userNews").document("placeholder").updateData(
            [
                "username": article.username,
                "title": article.title,
                "content": article.content,
                "imageName": article.imageName,
                "lastUpdated": article.lastUpdated
            ]
        )
    }
    
    static func deleteUserNews(_ newsId: String){
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
