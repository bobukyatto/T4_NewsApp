//
//  SignUpViewController.swift
//  NewsApp
//
//  Created by M01-4 on 7/14/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var cfmpass: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
    }
    
    func validateFields() -> String? {
        // Check that all fields are filled in
        if email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            username.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
        
            return "Please fill in all fields"
        }
        
        // Check that passwords match
        if cfmpass.text != password.text {
            return "Passwords do not match"
        }
        
        return nil
    }
    
    @IBAction func signupTap(_ sender: Any) {
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            // There was an error
            showError(error!)
        }
        else {
            // Clean data
            let finalEmail = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let fullname = username.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let finalPassword = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            UserDataManager.createUser(User(uid: nil, email: finalEmail, password: finalPassword, fullName: fullname), onComplete: {
                err in
                
                if (err != nil) {
                    self.showError(err!)
                }
                else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            })
        }
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func showAlert() {
        let alert = UIAlertController(
            title: "Welcome to NewsReveal!",
            message: "You have been successfully registered, please login.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
}
