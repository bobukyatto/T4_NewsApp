//
//  OfficialNewsDetailsViewController.swift
//  NewsApp
//
//  Created by Joel on 15/7/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit
import SwiftSoup
import AVFoundation

// TODO: Scrape article text content
class OfficialNewsDetailsViewController: UIViewController, AVSpeechSynthesizerDelegate {
    @IBOutlet var srcImgView: UIImageView!
    @IBOutlet var srcLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var articleImgView: UIImageView!
    @IBOutlet var ttsBtn: UIButton!
    @IBOutlet var contentTxtView: UITextView!
    
    var article: OfficialNewsArticle?
    var contentTxtViewWidth: CGFloat = 0
    let synth = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        synth.delegate = self
        
        loadingAlertPresent(loadingText: "Loading Article...")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        
        srcLabel.text = article?.source
        dateLabel.text = dateFormatter.string(from: article?.publishDate ?? Date())
        titleLabel.text = article?.title
        
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
        scrapeNews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        contentTxtViewWidth = contentTxtView.frame.width
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        synth.stopSpeaking(at: .immediate)
    }
    
    @IBAction func ttsBtn_Touch_Inside(_ sender: Any) {
        if !synth.isSpeaking {
            let utterance = AVSpeechUtterance(attributedString: contentTxtView.attributedText)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                
            synth.speak(utterance)
            
            (sender as AnyObject).setTitle("Pause Reading", for: .normal)
            (sender as AnyObject).setTitleColor(.red, for: .normal)
        }
        else if synth.isPaused {
            synth.continueSpeaking()
            
            (sender as AnyObject).setTitle("Pause Reading", for: .normal)
            (sender as AnyObject).setTitleColor(.red, for: .normal)
        }
        else {
            synth.pauseSpeaking(at: .immediate)
            
            (sender as AnyObject).setTitle("Continue Reading", for: .normal)
            (sender as AnyObject).setTitleColor(.systemBlue, for: .normal)
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        ttsBtn.setTitle("Start Reading", for: .normal)
        ttsBtn.setTitleColor(.systemBlue, for: .normal)
    }
    
    func scrapeNews() {
        let url = URL(string: article?.url ?? "")
        
        URLSession.shared.dataTask(with: url!, completionHandler:  {
            data, res, err in
            
            let htmlStr: String = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
            var htmlData: Data?;
            
            if (htmlStr != "") {
                let doc: Document = try! SwiftSoup.parse(htmlStr)
                
                switch self.article?.source.lowercased() {
                    case "the straits times":
                        try! doc.select(".field .field-item figure.image img").attr("width", "\(self.contentTxtViewWidth)")
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

                    self.contentTxtView.attributedText = attrStr
                    
                    self.dismiss(animated: false, completion: nil)
                }
            }
        }).resume()
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
