//
//  OfficialNewsDataManager.swift
//  NewsApp
//
//  Created by Joel on 1/7/20.
//  Copyright © 2020 M02-4. All rights reserved.
//
import UIKit

class OfficialNewsDataManager: NSObject {
    class func getTopHeadlines(query: String?, onComplete: ((_: [OfficialNewsArticle]) -> Void)?) {
        let q = query == nil ? "" : "&\(query?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ?? "")"
        let url = "https://newsapi.org/v2/top-headlines?country=sg\(q)&apiKey=3837e3a4044b4f33ae22d5d0ecb07a22"
        
        HTTP.getJSON(url: url, onComplete: {
            json, resp, err in
            
            if err != nil {
                return
            }
            
            let result = json!
            var articleList: [OfficialNewsArticle] = []
            
            for i in 0 ..< result["articles"].count {
                let a = result["articles"][i]
                let source = a["source"]["name"].string
                
                articleList.append(
                    OfficialNewsArticle(
                        source: source ?? "",
                        title: a["title"].string ?? "",
                        desc: a["description"].string ?? "",
                        url: a["url"].string ?? "",
                        urlImg: a["urlToImage"].string ?? "",
                        publishDate: a["publishedAt"].string ?? ""
                    )
                )
                
                onComplete?(articleList)
            }
        })
    }
}
