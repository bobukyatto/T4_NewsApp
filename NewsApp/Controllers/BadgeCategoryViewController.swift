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
        let query = badgeTypeRef.whereField("badgeCategory", isEqualTo: "3k9VU17auILyTXwwjU2t")
        
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let badgeCategory = document.data()["badgeCategory"]! as! String
                    let badgeTitle = document.data()["badgeTitle"]! as! String
                    let badgeDescription = document.data()["badgeDescription"]! as! String
                    let badgeImage = document.data()["badgeImage"]! as! String
                    let badgeMaxProgression = document.data()["badgeMaxProgression"]! as! Int
                    self.BadgeTypeList.append(BadgeType(Category: badgeCategory, Title: badgeTitle, Description: badgeDescription, Image: badgeImage, ProgressionMax: badgeMaxProgression))
                    
                    print(document.data()["badgeCategory"]!)
                    print("\(document.documentID) => \(document.data())")
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
