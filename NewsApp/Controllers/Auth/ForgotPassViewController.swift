//
//  ForgotPassViewController.swift
//  NewsApp
//
//  Created by ITP312Grp2 on 22/7/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPassViewController: UIViewController {

    @IBOutlet weak var ErrorLabel: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var sendLink: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendLinkTap(_ sender: Any) {
    
    }
}
