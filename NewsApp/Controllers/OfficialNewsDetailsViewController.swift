//
//  OfficialNewsDetailsViewController.swift
//  NewsApp
//
//  Created by Joel on 15/7/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit

// TODO: Scrape article text content
class OfficialNewsDetailsViewController: UIViewController {
    @IBOutlet var srcImgView: UIImageView!
    @IBOutlet var srcLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var articleImgView: UIImageView!
    @IBOutlet var contentTxtView: UITextView!
    
    var article: OfficialNewsArticle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        
        srcLabel.text = article?.source
        dateLabel.text = dateFormatter.string(from: article?.publishDate ?? Date())
        
        switch article?.source.lowercased() {
            case "the straits times":
                srcImgView.image = UIImage(named: "straits-times")
                break
            case "cna":
                srcImgView.image = UIImage(named: "cna")
                break
            default:
                break
        }
        
        articleImgView.loadFromUrl(defaultImgName: "logo", withUrl: article?.urlImg ?? "")
        
        self.navigationItem.title = article?.title
        
        /*
        let url = URL(string: article?.url ?? "")
        
        URLSession.shared.dataTask(with: url!, completionHandler:  {
            data, res, err in
            
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) ?? "")
        }).resume()
        */
    }
}

let imageCache = NSCache<NSString, AnyObject>()

// load image from url async
extension UIImageView {
    func loadFromUrl(defaultImgName: String, withUrl urlString: String) {
        let url = URL(string: urlString)
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }

        URLSession.shared.dataTask(with: url!, completionHandler: {
            data, res, err in
            
            if err != nil {
                self.image = UIImage(named: defaultImgName)
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                }
            }
        }).resume()
    }
}
