//
//  BadgeViewController.swift
//  NewsApp
//
//  Created by 145532G  on 7/18/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit

class BadgeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    var BadgeCategories:[Badge]=[]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        BadgeCategories.append(Badge(Name: "Category 1", Image: "1.png", ProgressionCurrent:1 , ProgressionMax: 5))
        BadgeCategories.append(Badge(Name: "Category 2", Image: "2.png", ProgressionCurrent:5 , ProgressionMax: 10))
        BadgeCategories.append(Badge(Name: "Category 3", Image: "3.png", ProgressionCurrent:10 , ProgressionMax: 15))
    }
    
    // This is a function that the UITableViewDataSource// should implement. It tells the UITableView how many // rowsthere will be.//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{BadgeCategories.count}
    
    // This is a function that the UITableViewDataSource
    // must implement. It needs to create / reuse a UITableViewCell // and return it to the UITableView to draw on the screen.
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // First we query the table view to see if there are // any UITableViewCells that can be reused. iOS will // create a new one if there aren't any. //
        let cell : BadgeTableViewCell = tableView
        .dequeueReusableCell (withIdentifier: "BadgeTableViewCell", for: indexPath)
        as! BadgeTableViewCell
        
        // Using the re-used cell, or the newly created// cell, we update the text label's text property.//
        
        let p = BadgeCategories[indexPath.row]
        cell.textLabel?.text = " test"
        cell.BadgeCategoryLabel.text = p.badgeCategoryName
        cell.BadgeProgressionLabel.text = "\(p.badgeCategoryProgressionCurrent) / \(p.badgeCategoryProgressionMax) Badges Earned"
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
