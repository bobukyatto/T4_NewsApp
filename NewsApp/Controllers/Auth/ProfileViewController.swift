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

class ProfileViewController: UIViewController {
    @IBOutlet weak var signoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signoutTap(_ sender: Any) {
        UserDataManager.signOut()
        guard let authVc = storyboard?.instantiateViewController(identifier: "AuthVc") as? AuthViewController else { return }
        var vc = self.navigationController?.viewControllers
        _ = vc?.popLast()
        vc?.append(authVc)
        
        self.navigationController?.setViewControllers(vc!, animated: false)
    }
}


