//
//  SignUpViewController.swift
//  NewsApp
//
//  Created by M01-4 on 7/14/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import GoogleSignIn

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var cfmpass: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var googlesignIn: GIDSignInButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        // Do any additional setup after loading the view.
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
    }
    
    // is email valid?
    func isEmailValid(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"

        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }

    // is password valid?
    func isPasswordValid(_ password: String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@",
            "^(?=.*[a-z])(?=.[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        
        return passwordTest.evaluate(with:password)
    }
    
    

    // Validation
    func validateFields() -> String? {
        // Check that all fields are filled in
        if email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            username.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        
        // Check that email is valid
        let finalEmail = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isEmailValid(finalEmail) == false {
            return "Please enter a valid email"
        }
        
        // Check that passwords match
        if cfmpass.text != password.text {
            return "Passwords do not match"
        }
        
        // Check that the password is secure
        let finalPassword = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isPasswordValid(finalPassword) == false {
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
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
    
    
}
