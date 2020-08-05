//
//  OfficialNewsDataManager.swift
//  NewsApp
//
//  Created by Joel on 1/7/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class OfficialNewsDataManager: NSObject {
    static let db = Firestore.firestore()
    private static let newsRef = db.collection("officialNews")
    
    // Store or retrive from DB with 60 mins interval check to prevent hitting API call limit
    static func loadNews(onComplete: (([OfficialNewsArticle]) -> Void)?) {
        let taskGroup = DispatchGroup()
        let dbLastModifiedDM = DBLastModifiedDataManager()
        
        var updateFlag = false
        var dbLastModified: [DBLastModified] = []
        var delArticles: [OfficialNewsArticle] = []
        var newsArticles: [OfficialNewsArticle] = []
        
        taskGroup.enter()
        dbLastModifiedDM.getLastModified(onComplete: {
            results in dbLastModified.append(contentsOf: results)
            
            taskGroup.enter()
            self.getOfficialNews(onComplete: {
                results in newsArticles.append(contentsOf: results)
                
                if let idx: Int = dbLastModified.firstIndex(where: { $0.table == "officialNews" }) {
                    let lastModified: Int = Calendar.current.dateComponents([.minute], from: dbLastModified[idx].lastModified, to: Date()).minute ?? 0
                    
                    updateFlag = lastModified > 60 || newsArticles.count < 1 ? true : false
                }
                else {
                    updateFlag = true
                }
                
                if updateFlag {
                    delArticles = newsArticles
                    newsArticles = []
                    
                    taskGroup.enter()
                    self.newsSearchApi(params: "q= &domains=straitstimes.com&pageSize=50", onComplete: {
                        results in newsArticles.append(contentsOf: results)
                        taskGroup.leave()
                    })
                    
                    taskGroup.enter()
                    self.newsSearchApi(params: "q= &domains=channelnewsasia.com&pageSize=50", onComplete: {
                        results in newsArticles.append(contentsOf: results)
                        taskGroup.leave()
                    })
                }
                
                taskGroup.leave()
            })
            
            taskGroup.leave()
        })
        
        taskGroup.notify(queue: .main, execute: {
            if updateFlag {
                newsArticles.sort(by: { $0.publishDate > $1.publishDate })
                self.deleteMultiOfficialNews(delArticles)
                self.insertMultiOfficialNews(newsArticles)
                
                dbLastModifiedDM.insertReplaceLastModified(DBLastModified(table: "officialNews", lastModified: Date()))
            }
            
            onComplete?(newsArticles)
        })
    }
    
    static func newsSearchApi(params: String?, onComplete: (([OfficialNewsArticle]) -> Void)?) {
        let url = "https://newsapi.org/v2/everything?\(params ?? "")&apiKey=3837e3a4044b4f33ae22d5d0ecb07a22".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        HTTP.getJSON(url: url, onComplete: {
            json, res, err in
            
            if err != nil {
                return
            }
            
            let results = json!
            var newsArticles: [OfficialNewsArticle] = []
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            
            for i in 0 ..< results["articles"].count {
                let a = results["articles"][i]
                
                newsArticles.append(
                    OfficialNewsArticle(
                        id: nil,
                        source: a["source"]["name"].string ?? "",
                        title: a["title"].string ?? "",
                        desc: a["description"].string ?? "",
                        url: a["url"].string ?? "",
                        urlImg: a["urlToImage"].string ?? "",
                        publishDate: dateFormatter.date(from: a["publishedAt"].string!)!
                    )
                )
            }
            
            onComplete?(newsArticles)
        })
    }
    
    private static func getOfficialNews(onComplete: (([OfficialNewsArticle]) -> Void)?) {
        newsRef.order(by: "publishDate").getDocuments() {
            (snapshot, err) in
            
            var articleList: [OfficialNewsArticle] = []
            
            if let err = err {
                print("OfficialNewsDataManager: \(err)")
            }
            else {
                for document in snapshot!.documents {
                    let item = try? document.data(as: OfficialNewsArticle.self)!
                    
                    if item != nil {
                        articleList.append(item!)
                    }
                }
            }
            
            onComplete?(articleList)
        }
    }
    
    private static func insertMultiOfficialNews(_ articleList: [OfficialNewsArticle]) {
        for (i, item) in articleList.enumerated() {
            _ = try? self.newsRef.addDocument(from: item, encoder: Firestore.Encoder()) {
                err in
                
                if let err = err {
                    print("OfficialNewsDataManager: \(err)")
                }
                
                if (i >= articleList.count - 1) {
                    print("OfficialNewsDataManager: Add successful!")
                }
            }
        }
    }
    
    private static func deleteMultiOfficialNews(_ articleList: [OfficialNewsArticle]) {
        for (i, item) in articleList.enumerated() {
            if (item.id != nil) {
                self.newsRef.document(item.id!).delete() {
                    err in
                    
                    if let err = err {
                        print("OfficialNewsDataManager: \(err)")
                    }
                    else if (i >= articleList.count - 1) {
                        print("OfficialNewsDataManager: Delete successful!")
                    }
                }
            }
        }
    }
}
