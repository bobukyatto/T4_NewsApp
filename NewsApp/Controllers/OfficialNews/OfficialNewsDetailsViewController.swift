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
    @IBOutlet var bookmarkBtn: UIButton!
    
    var userStateChanged: Bool = false
    var bookmark: Bookmark?
    var article: OfficialNewsArticle?
    var contentTxtViewWidth: CGFloat = 0
    let synth = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        synth.delegate = self
        
        self.loadArticle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentTxtViewWidth = contentTxtView.frame.width
        
        self.getBookmark()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        synth.stopSpeaking(at: .immediate)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        ttsBtn.setTitle("Start Reading", for: .normal)
        ttsBtn.setTitleColor(.systemBlue, for: .normal)
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
            (sender as AnyObject).setTitleColor(.systemGreen, for: .normal)
        }
    }
    
    @IBAction func bookmarkBtn_Touch_Inside(_ sender: Any) {
        self.updateBookmark()
    }
    
    func loadArticle() {
        self.presentSpinnerAlert(title: nil, message: "Loading Article...")
        
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
        
        OfficialNewsHelper().scrapeArticle(article: article, currentUIelementWidth: contentTxtViewWidth, onComplete: {
            results in
            
            self.contentTxtView.attributedText = results
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    func getBookmark() {
        if UserDataManager.loggedIn != nil && article != nil {
            BookmarkDataManager.getBookmark(user: UserDataManager.loggedIn!, article: article!, onComplete: {
                result in
                
                self.bookmark = result
                self.updateBookmarkBtnState()
            })
        }
        else {
            self.updateBookmarkBtnState()
        }
    }
    
    func updateBookmark() {
        if self.bookmark != nil {
            BookmarkDataManager.deleteBookmark(bookmark: self.bookmark!)
            self.bookmark = nil
        }
        else {
            self.bookmark = Bookmark(
                id: nil,
                uid: (UserDataManager.loggedIn?.uid)!,
                type: "official",
                source: article!.source,
                title: article!.title,
                desc: article!.desc,
                url: article!.url,
                urlImg: article!.urlImg,
                publishDate: article!.publishDate,
                content: nil
            )
            
            BookmarkDataManager.addBookmark(bookmark: self.bookmark!)
        }
        
        self.updateBookmarkBtnState()
    }
    
    func updateBookmarkBtnState() {
        if UserDataManager.loggedIn != nil {
            self.bookmarkBtn.setTitle(self.bookmark == nil ? "Bookmark" : "Remove Bookmark", for: .normal)
            self.bookmarkBtn.setTitleColor(self.bookmark == nil ? .systemBlue : .systemRed, for: .normal)
            self.bookmarkBtn.isEnabled = true
        }
        else {
            self.bookmarkBtn.setTitle("Bookmark", for: .normal)
            self.bookmarkBtn.setTitleColor(.systemBlue, for: .normal)
            self.bookmarkBtn.setTitleColor(.systemGray, for: .disabled)
            self.bookmarkBtn.isEnabled = false
        }
    }
}
