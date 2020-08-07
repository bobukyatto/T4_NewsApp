//
//  BookmarksDataManager.swift
//  NewsApp
//
//  Created by Joel on 5/8/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class BookmarkDataManager: NSObject {
    static let db = Firestore.firestore()
    private static let bookmarksRef = db.collection("bookmarks")
    
    static func getUserBookmarks(user: User, onComplete: (([Bookmark]) -> Void)?) {
        bookmarksRef.getDocuments() {
            (snapshot, err) in
            
            var bookmarksList: [Bookmark] = []
            
            if user.uid != nil {
                if let err = err {
                    print("BookmarkDataManager: \(err)")
                }
                else {
                    for doc in snapshot!.documents {
                        let item = try? doc.data(as: Bookmark.self)!
                        
                        if item != nil {
                            bookmarksList.append(item!)
                        }
                    }
                }
            }
            
            onComplete?(bookmarksList)
        }
    }
    
    static func getBookmark(user: User, article: OfficialNewsArticle, onComplete: ((Bookmark?) -> Void)?) {
        bookmarksRef.whereField("uid", isEqualTo: user.uid!).whereField("title", isEqualTo: article.title).whereField("type", isEqualTo: "official").getDocuments() {
            (snapshot, err) in
            
            var bookmark: Bookmark?
            
            if let err = err {
                print("BookmarkDataManager: \(err)")
            }
            else {
                bookmark = try? snapshot?.documents.first?.data(as: Bookmark.self)
            }
            onComplete?(bookmark)
        }
    }
    
    static func getBookmark(user: User, article: UserNewsArticle, onComplete: ((Bookmark?) -> Void)?) {
        bookmarksRef.whereField("uid", isEqualTo: user.uid!).whereField("title", isEqualTo: article.title).whereField("type", isEqualTo: "user").getDocuments() {
            (snapshot, err) in
            
            var bookmark: Bookmark?
            
            if let err = err {
                print("BookmarkDataManager: \(err)")
            }
            else {
                bookmark = try? snapshot?.documents.first?.data(as: Bookmark.self)
            }
            onComplete?(bookmark)
        }
    }
    
    static func addBookmark(bookmark: Bookmark) {
        try? bookmarksRef.document().setData(from: bookmark) {
            err in
            
            if let err = err {
                print("BookmarkDataManager: \(err)")
            }
            else {
                print("BookmarkDataManager: Add successful!")
            }
        }
    }
    
    static func deleteBookmark(bookmark: Bookmark) {
        if bookmark.id != nil {
            bookmarksRef.document(bookmark.id!).delete() {
                err in
                
                if let err = err {
                    print("BookmarkDataManager: \(err)")
                }
                else {
                    print("BookmarkDataManager: Add successful!")
                }
            }
        }
    }
}
