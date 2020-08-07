//
//  BooksmarksDetailsViewController.swift
//  NewsApp
//
//  Created by Joel on 5/8/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit
import AVFoundation

class BooksmarksDetailsViewController: UIViewController, AVSpeechSynthesizerDelegate {
    @IBOutlet var srcImgView: UIImageView!
    @IBOutlet var srcLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var articleImgView: UIImageView!
    @IBOutlet var ttsBtn: UIButton!
    @IBOutlet var bookmarkBtn: UIButton!
    @IBOutlet var contentTxtView: UITextView!
    
    var returnRemovedBookmark: ((Bookmark?) -> ())?
    var removedBookmark: Bookmark?
    
    var bookmark: Bookmark?
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
        self.updateBookmarkBtnState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        synth.stopSpeaking(at: .immediate)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        ttsBtn.setTitle("Start Reading", for: .normal)
        ttsBtn.setTitleColor(.systemBlue, for: .normal)
    }
    
    @IBAction func ttsBtn_touch_inside(_ sender: Any) {
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
    
    @IBAction func bookmarkBtn_touch_inside(_ sender: Any) {
        self.updateBookmark()
    }
    
    func loadArticle() {
        self.presentSpinnerAlert(title: nil, message: "Loading Article...")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        
        srcLabel.text = bookmark?.source
        dateLabel.text = dateFormatter.string(from: bookmark?.publishDate ?? Date())
        titleLabel.text = bookmark?.title
        
        if bookmark?.type == "official" {
            switch bookmark?.source.lowercased() {
                case "the straits times":
                    srcImgView.image = UIImage(named: "straits-times")
                    break
                case "cna":
                    srcImgView.image = UIImage(named: "cna")
                    break
                default:
                    break
            }
            
            articleImgView.loadFromUrl(defaultImgName: "logo", withUrl: bookmark?.urlImg ?? "")
            
            OfficialNewsHelper().scrapeArticle(bookmark: bookmark, currentUIelementWidth: contentTxtViewWidth, onComplete: {
                results in
                
                self.contentTxtView.attributedText = results
                self.dismiss(animated: false, completion: nil)
            })
        }
    }
    
    func updateBookmark() {
        if self.bookmark != nil {
            BookmarkDataManager.deleteBookmark(bookmark: self.bookmark!)
            self.removedBookmark = self.bookmark
            self.bookmark = nil
        }
        else {
            BookmarkDataManager.addBookmark(bookmark: self.bookmark!)
            self.removedBookmark = nil
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
    
    func removeBookmarkCallback() {
        returnRemovedBookmark?(self.removedBookmark)
    }
}
