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

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func sendLinkTap(_ sender: Any) {
    
    }
    
}