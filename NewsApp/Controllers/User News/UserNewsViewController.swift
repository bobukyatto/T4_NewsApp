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
        let cell: UserNewsCell = tableView.dequeueReusableCell(withIdentifier: "UserNewsCell", for: indexPath) as! UserNewsCell
        return cell
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem =
            UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(uploadButtonClicked))
        // Do any additional setup after loading the view.
    }
    
    @objc func uploadButtonClicked( ){
        // Loads the UserNews.storyboard file
              let s = UIStoryboard(name: "UserNews", bundle: nil)
        // Loads next level View Controller from
        // UserNews.storyboard
        let v = s.instantiateViewController(withIdentifier:
                  "UserNewsForm")
        // Pushes the newly loaded view controller on
        // to the stack.
        self.navigationController?.pushViewController(v, animated: true)
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
