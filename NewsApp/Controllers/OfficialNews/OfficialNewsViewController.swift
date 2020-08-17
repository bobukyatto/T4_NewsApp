//
//  OfficialNewsViewController.swift
//  NewsApp
//
//  Created by Joel on 1/7/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit

class OfficialNewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet var tableView: UITableView!
    
    var tableList: [String: [OfficialNewsArticle]] = [
        "The Straits Times": [],
        "CNA": []
    ]
    var newsList: [String: [OfficialNewsArticle]] = [
        "The Straits Times": [],
        "CNA": []
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadNews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowOfficialNewsDetails") {
            let detailVC = segue.destination as! OfficialNewsDetailsViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            
            if (indexPath != nil) {
                detailVC.article = tableList[Array(tableList.keys)[indexPath!.section]]?[indexPath!.row]
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchNews(searchText: searchBar.text ?? "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            tableList = newsList
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
        let cell: OfficialNewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! OfficialNewsTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        
        let key = Array(tableList.keys)[indexPath.section]
        let n = tableList[key]![indexPath.row]
        cell.dateLabel!.text = dateFormatter.string(from: n.publishDate)
        cell.titleLabel!.text = n.title
        
        switch n.source.lowercased() {
            case "the straits times":
                cell.newsImageView.image = UIImage(named: "straits-times")
                break
            case "cna":
                cell.newsImageView.image = UIImage(named: "cna")
                break
            default:
                break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < tableList.count {
            return Array(tableList.keys)[section]
        }
        
        return nil
    }
    
    func loadNews() {
        self.presentSpinnerAlert(message: "Loading List...")
        
        OfficialNewsDataManager.loadNews(onComplete: {
            results in
            
            for item in results {
                if item.source.lowercased() == "cna" {
                    let key = item.source.uppercased()
                    
                    if (self.newsList[key] == nil) {
                        self.newsList[key] = []
                    }
                    
                    self.newsList["CNA"]?.append(item)
                }
                else if item.source.lowercased() == "the straits times" {
                    let key = item.source.capitalized
                    
                    if (self.newsList[key] == nil) {
                        self.newsList[key] = []
                    }
                    
                    self.newsList[key]?.append(item)
                }
            }
            
            self.tableList = self.newsList
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.dismiss(animated: false, completion: nil)
            }
        })
    }
    
    func searchNews(searchText: String) {
        self.presentSpinnerAlert(message: "Searching...")
        
        let taskGroup = DispatchGroup()
        
        if !searchText.isEmpty {
            for item in self.tableList {
                self.tableList[item.key] = []
            }
            
            taskGroup.enter()
            OfficialNewsDataManager.newsSearchApi(params: "qInTitle=\(searchText)&domains=straitstimes.com&pageSize=100", onComplete: {
                results in self.tableList["The Straits Times"]?.append(contentsOf: results)
                taskGroup.leave()
            })
            
            taskGroup.enter()
            OfficialNewsDataManager.newsSearchApi(params: "qInTitle=\(searchText)&domains=channelnewsasia.com&pageSize=100", onComplete: {
                results in self.tableList["CNA"]?.append(contentsOf: results)
                taskGroup.leave()
            })
        }
        
        taskGroup.notify(queue: .main, execute: {
            for item in self.tableList {
                self.tableList[item.key]?.sort(by: { $0.publishDate > $1.publishDate })
            }
            
            self.tableView.reloadData()
            self.dismiss(animated: false, completion: nil)
        })
    }
}
