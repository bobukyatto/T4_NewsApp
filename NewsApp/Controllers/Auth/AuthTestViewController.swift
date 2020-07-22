//
//  ProfileViewController.swift
//  NewsApp
//
//  Created by M01-4 on 7/14/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AuthTestViewController: UIViewController {

    @IBOutlet weak var signoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
 
        // Do any additional setup after loading the view.
    }
    
   
    @IBAction func signoutTap(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        
        do {
          try firebaseAuth.signOut()
            transitiontoLogin()
            
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    
    }
    
     func transitiontoLogin() {
           
           let loginViewController =
               storyboard?.instantiateViewController(identifier:
                   Constants.Storyboard.loginViewController) as? LoginViewController
           
           view.window?.rootViewController = loginViewController
           view.window?.makeKeyAndVisible()
        
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


