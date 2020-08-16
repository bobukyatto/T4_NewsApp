//
//  UserNewsViewController.swift
//  NewsApp
//
//  Created by ITP312Grp2 on 15/7/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit

class UserNewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var newsTableView: UITableView!
    var newsList: [UserNewsArticle] = []

    override func prepare(for segue : UIStoryboardSegue, sender: Any?){
        if segue.identifier == "ShowUserNewsDetails"
        {
            let destViewController = segue.destination as! UserNewsDetailViewController
            let myIndexPath = self.newsTableView.indexPathForSelectedRow
            if myIndexPath != nil
            {
                let userNews = newsList[myIndexPath!.row]
                destViewController.usernewsItem = userNews
            }
        }
    }
    
    
    
    func loadNews(){
        UserNewsDataManager.loadUserNews(){
            newsListFromFireStore in
            self.newsList = newsListFromFireStore
            DispatchQueue.main.async {
                self.newsTableView.reloadData()
            }
             
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserNewsCell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! UserNewsCell
        let p = newsList[indexPath.row]

        cell.UNameLabel?.text = "\(p.title)"
        cell.UDateLabel?.text = "\(p.date)"
        cell.UsernameLabel?.text = "test"
        cell.UNewsImage?.image = nil
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete
        {
            newsList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem =
            UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(uploadButtonClicked))
        
        loadNews()
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
