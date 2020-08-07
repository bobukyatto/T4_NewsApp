//
//  UserNewsDetailViewController.swift
//  NewsApp
//
//  Created by ITP312Grp2 on 1/7/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit

class UserNewsDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernewsImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var imgPicker = UIImagePickerController()
    
    var bookmark: Bookmark?
    var usernewsItem: UserNewsArticle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getBookmark()
    }
    
    /* TODO: Call in bookmarkBtn touch inside.
    * Suggesst changing date variable in UserNewsArticle model,
    * from String to Date format.
    * Can check OfficialNewsArticle model, and
    * OfficialNewsViewController DateFormatter(),
    * around line 68 on how to format Date data
    * type to String for display. If UserNewsArticle date
    * variable is changed to Date data type, dateFormatter
    * below can be removed and just use usernewsItem.date
    * for the Bookmark() parameter.
    */
    func updateBookmark() {
        if self.bookmark != nil {
            BookmarkDataManager.deleteBookmark(bookmark: self.bookmark!)
            self.bookmark = nil
        }
        else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: usernewsItem?.date ?? "")
            
            self.bookmark = Bookmark(
                id: nil,
                uid: (UserDataManager.loggedIn?.uid)!,
                type: "user",
                source: nil,
                title: usernewsItem?.title ?? "",
                desc: nil,
                url: nil,
                urlImg: usernewsItem?.imageName ?? "",
                publishDate: date!,
                content: usernewsItem?.content
            )
            
            BookmarkDataManager.addBookmark(bookmark: self.bookmark!)
        }
        
        self.updateBookmarkBtnState()
    }
    
    func getBookmark() {
        if UserDataManager.loggedIn != nil && usernewsItem != nil {
            BookmarkDataManager.getBookmark(user: UserDataManager.loggedIn!, article: usernewsItem!, onComplete: {
                result in
                
                self.bookmark = result
                self.updateBookmarkBtnState()
            })
        }
        else {
            self.updateBookmarkBtnState()
        }
    }
    

    // TODO: create bookmarkBtn and link as @IBOutlet var and update self.bookmarkBtn below
    func updateBookmarkBtnState() {
        if UserDataManager.loggedIn != nil {
            /*
            self.bookmarkBtn.setTitle(self.bookmark == nil ? "Bookmark" : "Remove Bookmark", for: .normal)
            self.bookmarkBtn.setTitleColor(self.bookmark == nil ? .systemBlue : .systemRed, for: .normal)
            self.bookmarkBtn.isEnabled = true
            */
        }
        else {
            /*
            self.bookmarkBtn.setTitle("Bookmark", for: .normal)
            self.bookmarkBtn.setTitleColor(.systemBlue, for: .normal)
            self.bookmarkBtn.setTitleColor(.systemGray, for: .disabled)
            self.bookmarkBtn.isEnabled = false
             */
        }
    }
}
