//
//  BadgeCategoryViewController.swift
//  NewsApp
//
//  Created by ITP312Grp2 on 29/7/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class BadgeCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    
    
    var BadgeTypeList:[BadgeType]=[]
    var BadgeCategory: String = ""
    var BadgeCategoryID: String = ""
    let db = Firestore.firestore()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        BadgeTypeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : badgeTypeCell = tableView
        .dequeueReusableCell (withIdentifier: "badgeTypeCell", for: indexPath)
        as! badgeTypeCell
        let p = BadgeTypeList[indexPath.row]
        
        cell.badgeTypeTitleLabel.text = p.badgeTitle
        cell.badgeTypeProgressionLabel.text = String(p.badgeProgressionCurrent)+" out of " + String(p.badgeProgressionMax)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //set title
        self.navigationItem.title = BadgeCategory

        //Load badge categories from firestore
        
        // Create a reference to the cities collection
        let badgeTypeRef = db.collection("badgeType")

        // Create a query against the collection.
        let query = badgeTypeRef.whereField("badgeCategory", isEqualTo: BadgeCategoryID)
        
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let badgeID = document.documentID
                    let badgeCategory = document.data()["badgeCategory"]! as! String
                    let badgeTitle = document.data()["badgeTitle"]! as! String
                    let badgeDescription = document.data()["badgeDescription"]! as! String
                    let badgeImage = document.data()["badgeImage"]! as! String
                    let badgeMaxProgression = document.data()["badgeMaxProgression"]! as! Int
                    self.BadgeTypeList.append(BadgeType(ID: badgeID, Category: badgeCategory, Title: badgeTitle, Description: badgeDescription, Image: badgeImage, ProgressionMax: badgeMaxProgression))
                    
                    print(document.data()["badgeCategory"]!)
                    print("\(document.documentID) => \(document.data())")
                }
            }
            //reload the table view after getting data from firebase
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        // TODO promise run after above has completed
        let currentLoggedInUserID = UserDataManager.loggedIn!.uid!
        let userBadgeRef = db.collection("userBadges")
        let userBadgeQuery = userBadgeRef.whereField("userID", isEqualTo: currentLoggedInUserID)
        userBadgeQuery.getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                print("test")
                print(self.BadgeTypeList.count)
                for something in self.BadgeTypeList {
                    let badgeTypeID = document.data()["badgeTypeID"]! as! String
                    let userBadgeProgressionCurrent = document.data()["badgeProgressionCurrent"]! as! Int
                    if (badgeTypeID == something.badgeID){
                        something.badgeProgressionCurrent = userBadgeProgressionCurrent
                        print(userBadgeProgressionCurrent)
                        print(something.badgeProgressionCurrent)
                    }
                }
                
                }
                    }
                    //reload the table view after getting data from firebase
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
