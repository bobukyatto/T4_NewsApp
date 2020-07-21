//
//  UserNewsViewController.swift
//  NewsApp
//
//  Created by ITP312Grp2 on 15/7/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit

class UserNewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var newsList: [UserNewsArticle] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserNewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserNewsCell", for: indexPath) as! UserNewsTableViewCell
        return cell
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Do any additional setup after loading the view.
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
