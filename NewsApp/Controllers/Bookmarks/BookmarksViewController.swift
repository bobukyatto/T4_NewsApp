//
//  BookmarksViewController.swift
//  NewsApp
//
//  Created by Joel on 1/8/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit

class BookmarksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    var newsList: [String: [Bookmark]] = [
        "Official News": [],
        "User News": []
    ]
    var tableList: [String: [Bookmark]] = [
        "Official News": [],
        "User News": []
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < tableList.count {
            return tableList[Array(tableList.keys)[section]]!.count
        }
        
        return 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return tableList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BookmarksTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! BookmarksTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        
        let key = Array(tableList.keys)[indexPath.section]
        let n = tableList[key]![indexPath.row]
        cell.dateLabel!.text = dateFormatter.string(from: n.publishDate)
        cell.titleLabel!.text = n.title
        
        if n.type == "official" {
            switch n.source.lowercased() {
                case "the straits times":
                    cell.srcImgView.image = UIImage(named: "straits-times")
                    break
                case "cna":
                    cell.srcImgView.image = UIImage(named: "cna")
                    break
                default:
                    break
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < tableList.count {
            return Array(tableList.keys)[section]
        }
        
        return nil
    }
    
    func loadBookmarks() {
        self.loadingAlertPresent(loadingText: "Loading List...")
        
        let user = UserDataManager.loggedIn
        
        if user != nil {
            BookmarkDataManager.getUserBookmarks(user: user!, onComplete: {
                results in
                
                for bookmark in results {
                    if bookmark.type == "official" {
                        self.newsList["Official News"]?.append(bookmark)
                    }
                    else {
                        self.newsList["User News"]?.append(bookmark)
                    }
                }
                
                self.tableList = self.newsList
            })
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func loadingAlertPresent(loadingText: String) {
        let loadAlert = UIAlertController(title: nil, message: loadingText, preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating();

        loadAlert.view.addSubview(loadingIndicator)
        self.present(loadAlert, animated: false, completion: nil)
    }
}
