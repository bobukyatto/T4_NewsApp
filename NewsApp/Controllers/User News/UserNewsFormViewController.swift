//
//  UserNewsFormViewController.swift
//  NewsApp
//
//  Created by Sharon on 22/7/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit

class UserNewsFormViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageSelectButton: UIButton!
    
    @IBOutlet weak var imageLabel: UILabel!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func submitButtonPressed(_ sender: UIButton) {
        let imageName = (imageLabel.text ?? "imgName")!
        let title = (titleTextField.text ?? "title")!
        let content = (contentTextView.text ?? "content")!
        
        // gets today's date
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = format.string(from: date)

        //instantiate UserNewsArticle
        let article: UserNewsArticle = UserNewsArticle("test", title, content, formattedDate, imageName, lastUpdated: formattedDate);
        
        //add article to collection userNews in FireStore
        UserNewsDataManager.addUserNews(article, UserNewsDataManager.getNoOfNews())
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
