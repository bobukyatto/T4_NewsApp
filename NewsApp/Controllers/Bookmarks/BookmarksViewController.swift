//
//  BookmarksViewController.swift
//  NewsApp
//
//  Created by Joel on 1/8/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit

class BookmarksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet var tableView: UITableView!
    
    var bookmarkList: [String: [Bookmark]] = [
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBookmarks()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowBookmarkDetails") {
            let detailVC = segue.destination as! BooksmarksDetailsViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            
            if (indexPath != nil) {
                detailVC.bookmark = tableList[Array(tableList.keys)[indexPath!.section]]?[indexPath!.row]
                detailVC.returnRemovedBookmark = {
                    result in
                    
                    if result != nil {
                        BookmarkDataManager.deleteBookmark(bookmark: result!)
                    }
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBookmarks(searchText: searchBar.text ?? "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            tableList = bookmarkList
            self.tableView.reloadData()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return tableList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < tableList.count {
            return tableList[Array(tableList.keys)[section]]!.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BookmarksTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BookmarksCell", for: indexPath) as! BookmarksTableViewCell
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
        self.presentSpinnerAlert(message: "Loading List...")
        
        for item in self.bookmarkList {
            self.bookmarkList[item.key] = []
            self.tableList[item.key] = []
        }
        
        let user = UserDataManager.loggedIn
        
        if user != nil {
            BookmarkDataManager.getUserBookmarks(user: user!, onComplete: {
                results in
                
                for bookmark in results {
                    if bookmark.type == "official" {
                        self.bookmarkList["Official News"]?.append(bookmark)
                    }
                    else {
                        self.bookmarkList["User News"]?.append(bookmark)
                    }
                }
                
                self.tableList = self.bookmarkList
                
                DispatchQueue.main.async {                    self.tableView.reloadData()
                    self.dismiss(animated: false, completion: nil)
                }
            })
        }
    }
    
    func searchBookmarks(searchText: String) {
        self.presentSpinnerAlert(message: "Searching...")
        
        if !searchText.isEmpty {
            for item in self.tableList {
                self.tableList[item.key] = []
                
                self.tableList[item.key] = self.bookmarkList[item.key]?.filter {
                    $0.title.contains(searchText)
                }
                
                self.tableList[item.key]?.sort(by: {
                    $0.publishDate > $1.publishDate
                })
            }
        }
        
        self.tableView.reloadData()
        self.dismiss(animated: false, completion: nil)
    }
}
