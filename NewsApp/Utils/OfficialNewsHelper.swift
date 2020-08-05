//
//  OfficialNewsHelper.swift
//  NewsApp
//
//  Created by Joel on 5/8/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit

class OfficialNewsHelper: NSObject {
    func scrapeArticle(article: OfficialNewsArticle?, currentUIelementWidth: CGFloat, onComplete: ((NSMutableAttributedString?) -> Void)?) {
        if article != nil && article?.url != "" && article?.url != nil {
            let url = URL(string: article!.url)
            
            URLSession.shared.dataTask(with: url!, completionHandler: {
                data, res, err in
                
                let htmlStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                var htmlData: Data?
                
                if (htmlStr != "") {
                    let doc: Document = try! SwiftSoup.parse(htmlStr)
                    
                    switch article!.source.lowercased() {
                        case "the straits times":
                            try! doc.select(".field .field-item figure.image img").attr("width", "\(currentUIelementWidth)")
                            try! doc.select(".field .field-item figure.image img").attr("height", "")
                            try! doc.select(".field .field-item h4").attr("style", "color: #36627b; font-size: 17px; font-weight: 900; font-family: Arial;")
                            try! doc.select(".field .field-item p:contains(Get The Straits Times app)").html("")
                            try! doc.select(".field .field-item p:contains(Read the latest on)").html("")
                            try! doc.select(".field .field-item p").attr("style", "font-size: 16px; font-family: Arial;")
                            
                            htmlData = NSString(string: try! doc.select(".field .field-item p:contains( ), .field .field-item h4:not(.related-story-headline, .label-above), .field .field-item figure.image img").outerHtml()).data(using: String.Encoding.utf8.rawValue)
                            break;
                        case "cna":
                            try! doc.select(".c-rte--article > p:contains(subscribe to our Telegram channel for the latest updates)").html("")
                            try! doc.select(".c-rte--article > p").attr("style", "font-size: 16px; font-family: Arial;")
                            
                            htmlData = NSString(string: try! doc.select(".c-rte--article > p:contains( )").outerHtml()).data(using: String.Encoding.utf8.rawValue)
                            break;
                        default:
                            break;
                    }
                }
                
                DispatchQueue.main.async {
                    if (htmlData != nil) {
                        let attrOpt = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
                        let attrStr = try! NSMutableAttributedString(data: htmlData!, options: attrOpt, documentAttributes: nil)

                        onComplete?(attrStr)
                    }
                }
            }).resume()
        }
        else {
            onComplete?(nil)
        }
    }
}
