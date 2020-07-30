//
//  OfficialNewsViewController.swift
//  NewsApp
//
//  Created by Joel on 1/7/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit

class OfficialNewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    
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
        loadNews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowOfficialNewsDetails") {
            let detailVC = segue.destination as! OfficialNewsDetailsViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            
            if (indexPath != nil) {
                let article = tableList[Array(tableList.keys)[indexPath!.section]]?[indexPath!.row]
                detailVC.article = article
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchNews(searchText: searchBar.text ?? "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
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
        
        return 1
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
        self.loadingAlertPresent(loadingText: "Loading List...")
        
        OfficialNewsDataManager().loadNews(onComplete: {
            results in
            
            for item in results {
                if item.source.lowercased() == "cna" {
                    self.newsList["CNA"]?.append(item)
                }
                else if item.source.lowercased() == "the straits times" {
                    self.newsList["The Straits Times"]?.append(item)
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
        let taskGroup = DispatchGroup()
        let officialNewsDM = OfficialNewsDataManager()
        
        loadingAlertPresent(loadingText: "Searching...")
        
        if searchText != "" {
            for item in self.tableList {
                self.tableList[item.key] = []
            }
            
            taskGroup.enter()
            officialNewsDM.newsSearchApi(params: "qInTitle=\(searchText)&domains=straitstimes.com&pageSize=100", onComplete: {
                results in self.tableList["The Straits Times"]?.append(contentsOf: results)
                taskGroup.leave()
            })
            
            taskGroup.enter()
            officialNewsDM.newsSearchApi(params: "qInTitle=\(searchText)&domains=channelnewsasia.com&pageSize=100", onComplete: {
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
