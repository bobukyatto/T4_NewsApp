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
    
    var newsList: [String: [OfficialNewsArticle]] = [
        "The Straits Times": [],
        "CNA": []
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNews(delayLoadingAlert: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowOfficialNewsDetails") {
            let detailVC = segue.destination as! OfficialNewsDetailsViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            
            if (indexPath != nil) {
                let article = newsList[Array(newsList.keys)[indexPath!.section]]?[indexPath!.row]
                detailVC.article = article
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchNews(searchText: searchBar.text ?? "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            loadNews(delayLoadingAlert: false)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < newsList.count {
            return newsList[Array(newsList.keys)[section]]!.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OfficialNewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! OfficialNewsTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        
        let key = Array(newsList.keys)[indexPath.section]
        let n = newsList[key]![indexPath.row]
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
        if section < newsList.count {
            return Array(newsList.keys)[section]
        }
        
        return nil
    }
    
    func loadNews(delayLoadingAlert: Bool) {
        // Delay alert present if initial load to avoid overla with launchScreen animation
        DispatchQueue.main.asyncAfter(deadline: .now() + (delayLoadingAlert ? 2 : 0), execute: {
            self.loadingAlertPresent(loadingText: "Loading List...")
        })
        
        OfficialNewsDataManager().loadNews(onComplete: {
            results in
            
            for item in self.newsList {
                self.newsList[item.key] = []
            }
            
            for item in results {
                if item.source.lowercased() == "cna" {
                    self.newsList["CNA"]?.append(item)
                }
                else if item.source.lowercased() == "the straits times" {
                    self.newsList["The Straits Times"]?.append(item)
                }
            }
            
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
            for item in self.newsList {
                self.newsList[item.key] = []
            }
            
            taskGroup.enter()
            officialNewsDM.newsSearchApi(params: "qInTitle=\(searchText)&domains=straitstimes.com&pageSize=100", onComplete: {
                results in self.newsList["The Straits Times"]?.append(contentsOf: results)
                taskGroup.leave()
            })
            
            taskGroup.enter()
            officialNewsDM.newsSearchApi(params: "qInTitle=\(searchText)&domains=channelnewsasia.com&pageSize=100", onComplete: {
                results in self.newsList["CNA"]?.append(contentsOf: results)
                taskGroup.leave()
            })
        }
        
        taskGroup.notify(queue: .main, execute: {
            for item in self.newsList {
                self.newsList[item.key]?.sort(by: { $0.publishDate > $1.publishDate })
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
