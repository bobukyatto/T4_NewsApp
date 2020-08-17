//
//  UserNewsFormViewController.swift
//  NewsApp
//
//  Created by Sharon on 22/7/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit

class UserNewsFormViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageSelectButton: UIButton!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    var imgPicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        
        // TODO: Store image into firebase storage
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
        UserNewsDataManager.addUserNews(article)
    }
    
    @IBAction func selectImgBtn_touch_inside(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            print(true)
            imgPicker.delegate = self
            imgPicker.sourceType = .photoLibrary
            imgPicker.allowsEditing = false
            
            present(imgPicker, animated: true, completion: nil)
        }
    }
}
