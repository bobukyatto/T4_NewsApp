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
    private static let bookmarksRef = db.collection("officialNews")
    
    static func getUserBookmarks(user: User, onComplete: (([Bookmark]) -> Void)?) {
        bookmarksRef.getDocuments() {
            (snapshot, err) in
            
            if (user.uid != nil) {
                var bookmarksList: [Bookmark] = []
                
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
                
                onComplete?(bookmarksList)
            }
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
