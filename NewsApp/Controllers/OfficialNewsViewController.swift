//
//  OfficialNewsViewController.swift
//  NewsApp
//
//  Created by Joel on 1/7/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit

class OfficialNewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var newsList: [OfficialNewsArticle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        // FIXME: Commented out loadTopHeadlines() to prevent hitting API call limit.
        // loadTopHeadlines(nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OfficialNewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! OfficialNewsTableViewCell
        
        let n = newsList[indexPath.row]
        cell.dateLabel!.text = n.publishDate
        cell.titleLabel!.text = n.title
        
        return cell
    }
    
    func loadTopHeadlines(_ query: String?) {
        OfficialNewsDataManager.getTopHeadlines(query: nil, onComplete: {
            (results) in self.newsList = results
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
}
