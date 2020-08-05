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
        
        loadArticle()
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
            (sender as AnyObject).setTitleColor(.systemGreen, for: .normal)
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        ttsBtn.setTitle("Start Reading", for: .normal)
        ttsBtn.setTitleColor(.systemBlue, for: .normal)
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
}
