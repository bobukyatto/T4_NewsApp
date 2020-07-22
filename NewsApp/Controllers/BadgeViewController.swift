//
//  BadgeViewController.swift
//  NewsApp
//
//  Created by 145532G  on 7/18/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class BadgeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    var BadgeCategories:[Badge]=[]
    let db = Firestore.firestore()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start additional setup after loading the view.
        
        //Load badge categories from firestore
        db.collection("badgeCategory").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let badgeTitle = document.data()["categoryTitle"]! as! String
                    let badgeImage = document.data()["categoryImage"]! as! String
                    self.BadgeCategories.append(Badge(Name: badgeTitle, Image: badgeImage, ProgressionCurrent:10 , ProgressionMax: 15))
                    
                    // for debugging
                    print (self.BadgeCategories.count)
                    print(document.data()["categoryTitle"]!)
                    print("\(document.documentID) => \(document.data())")
                }
            }
            //reload the table view after getting data from firebase
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        // Add a new badge document with a generated id.
        var ref: DocumentReference? = nil
        ref = db.collection("userBadges").addDocument(data: [
            "userID": "doUnOjdtuTNjdDdTQKEz3bkraBo2",
            "badgeTypeID": "VwHe6m6uYBnjKOJODmZr",
            "badgeProgressionCurrent":"4"
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
    }
    
    // This is a function that the UITableViewDataSource// should implement. It tells the UITableView how many // rowsthere will be.//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        BadgeCategories.count
        
    }
    
    // This is a function that the UITableViewDataSource
    // must implement. It needs to create / reuse a UITableViewCell // and return it to the UITableView to draw on the screen.
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // First we query the table view to see if there are // any UITableViewCells that can be reused. iOS will // create a new one if there aren't any. //
        let cell : BadgeTableViewCell = tableView
        .dequeueReusableCell (withIdentifier: "BadgeTableViewCell", for: indexPath)
        as! BadgeTableViewCell
        
        // Using the re-used cell, or the newly created// cell, we update the text label's text property.//
        
        let p = BadgeCategories[indexPath.row]
        cell.textLabel?.text = p.badgeCategoryName
        //cell.BadgeCategoryLabel.text = p.badgeCategoryName
        //cell.BadgeProgressionLabel.text = "\(p.badgeCategoryProgressionCurrent) / \(p.badgeCategoryProgressionMax) Badges Earned"
        // cell.BadgeImageView.image = UIImage(named: p.badgeCategoryImage)
        
        return cell
        
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
