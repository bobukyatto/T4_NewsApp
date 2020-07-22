//
//  LoginViewController.swift
//  NewsApp
//
//  Created by M01-4 on 7/14/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
        
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
   
    
    @IBOutlet weak var loginButton: UIButton!
    
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
        password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
    
        return "Please fill in all fields"
        
        }
        
        return nil
    }
    

    @IBAction func loginTap(_ sender: Any) {
        
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            // There was an error
            showError(error!)
            
        }
        
        else {
            let finalEmail = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let finalPassword = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Signing in the User
            Auth.auth().signIn(withEmail: finalEmail, password: finalPassword) { (result, error) in
                if error != nil {
        
                    self.showError("Invalid Username/Password")
                
                }
                
                else {
                    
                    self.transitiontoHome()
            
                }
            }
        }
    }
            
    func showError(_ message: String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
    
    func transitiontoHome() {
        
        let profileViewController =
            storyboard?.instantiateViewController(identifier:
                Constants.Storyboard.profileViewController) as? ProfileViewController
        
        view.window?.rootViewController = profileViewController
        view.window?.makeKeyAndVisible()
    }
    
}
