//
//  UserDataManager.swift
//  NewsApp
//
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class UserDataManager {
    static var db = Firestore.firestore()
    static var fbAuth = Auth.auth()
    
    /*
    * Use this to check for logged in user instead of fbAuth.currentUser,
    * easier to expand on if required additional field for user data to be retrieved too.
    */
    static var loggedIn: User?
    
    static func signOut() {
        do {
            try fbAuth.signOut()
            loggedIn = nil
        }
        catch let err as NSError {
            print("UuserDataManager: \(err)")
        }
    }
    
    static func signIn(_ user: User, onComplete: ((User?) -> Void)?) {
        let taskGroup = DispatchGroup()
        var u: User?
        
        taskGroup.enter()
        fbAuth.signIn(withEmail: user.email, password: user.password) {
            (result, error) in
            
            if error == nil {
                taskGroup.enter()
                getUser(user, onComplete: {
                    result in
                    
                    if (result != nil) {
                        u = result
                    }
                    
                    taskGroup.leave()
                })
            }
            
            taskGroup.leave()
        }
        
        taskGroup.notify(queue: .main, execute: {
            loggedIn = u
            onComplete?(u)
        })
    }
    
    static func createUser(_ user: User, onComplete: ((String?) -> Void)?) {
        let taskGroup = DispatchGroup()
        var err: String?
        
        taskGroup.enter()
        checkExist(user, onComplete: {
            result in
            
            if (result == nil) {
                taskGroup.enter()
                fbAuth.createUser(withEmail: user.email, password: user.password) {
                    (result, error) in
                    
                    if error != nil {
                        // There was an error
                        err = "Error creating User"
                    }
                    else {
                        let u = User(uid: result!.user.uid, email: user.email, password: user.password, fullName: user.fullName)
                        
                        taskGroup.enter()
                        _ = try? db.collection("users").addDocument(from: u, encoder: Firestore.Encoder()) {
                            error in
                            
                            if error != nil {
                                err =  "Error saving user data"
                            }
                            
                            taskGroup.leave()
                        }
                    }
                    
                    taskGroup.leave()
                }
            }
            else {
                err = "Email already registered"
            }
            
            taskGroup.leave()
        })
        
        taskGroup.notify(queue: .main, execute: {
            onComplete?(err)
        })
    }
    
    private static func checkExist(_ user: User, onComplete: ((User?) -> Void)?) {
        db.collection("users").getDocuments() {
            (snapshot, err) in
            
            var foundUser: User?
            
            if let err = err {
                print("UserDataManager: \(err)")
            }
            else {
                for doc in snapshot!.documents {
                    let item = try? doc.data(as: User.self)!
                    
                    if (item != nil && item?.email == user.email) {
                        foundUser = item
                        
                        break;
                    }
                }
            }
            
            onComplete?(foundUser)
        }
    }
    
    private static func getUser(_ user: User, onComplete: ((User?) -> Void)?) {
        var u: User?
        
        db.collection("users").getDocuments() {
            (snapshot, err) in
            
            if let err = err {
                print("UserDataManager: \(err)")
            }
            else {
                for doc in snapshot!.documents {
                    let item = try? doc.data(as: User.self)!
                    
                    if (item != nil && item?.email == user.email && item?.password == user.password) {
                        u = item
                        
                        break;
                    }
                }
            }

            onComplete?(u)
        }
    }
}
