//
//  BadgeViewController.swift
//  NewsApp
//
//  Created by 145532G  on 7/18/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class BadgeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    
    var badges: [String: [Badge]] = [:]
    var userBadges: [String: [BadgeUser]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadBadges()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return badges.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < badges.count {
            return badges[Array(badges.keys)[section]]!.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BadgeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BadgesCell", for: indexPath) as! BadgeTableViewCell
        
        let badgeKey = Array(badges.keys)[indexPath.section]
        let b = badges[badgeKey]![indexPath.row]
        let userBadge = userBadges[badgeKey]?.filter {
            $0.badgeId == b.id
        }
        let progress = userBadge != nil ? userBadge?.first?.current : 0
        
        cell.nameLabel!.text = b.name
        cell.descLabel!.text = b.description
        cell.progressLabel.text = "\(progress ?? 0) \\ \(b.max)"
        print(b.name)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < badges.count {
            return Array(badges.keys)[section]
        }
        
        return nil
    }
    
    func loadBadges() {
        let taskGroup = DispatchGroup()
        let user = UserDataManager.loggedIn
        
        if user != nil {
            taskGroup.enter()
            BadgeDataManager.getBadges(onComplete: {
                results in
                
                for badge in results {
                    let key = badge.category.capitalized
                    
                    if self.badges[key] == nil {
                        self.badges[key] = []
                    }

                    self.badges[key]?.append(badge)
                    
                    taskGroup.enter()
                    BadgeUserDataManager.getUserBadge(user: user!, badge: badge, onComplete: {
                        result in
                        
                        if result != nil {
                            let key = badge.category.capitalized
                            
                            if self.userBadges[key] == nil {
                                self.userBadges[key] = []
                            }
                            
                            self.userBadges[key]?.append(result!)
                        }
                        
                        taskGroup.leave()
                    })
                }
                
                taskGroup.leave()
            })
        }
        
        taskGroup.notify(queue: .main, execute: {
            self.tableView.reloadData()
        })
    }
}
