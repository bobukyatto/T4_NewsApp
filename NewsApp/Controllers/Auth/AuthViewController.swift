//
//  AuthViewController.swift
//  NewsApp
//
//  Created by Joel on 30/7/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit
import GoogleSignIn

class AuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (UserDataManager.loggedIn != nil) {
            guard let profileVc = storyboard?.instantiateViewController(identifier: "ProfileVc") as? ProfileViewController else { return }
            var vc = self.navigationController?.viewControllers
            _ = vc?.popLast()
            vc?.append(profileVc)
            
            self.navigationController?.setViewControllers(vc!, animated: false)
        }
    }
}
