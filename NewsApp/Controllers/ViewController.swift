//
//  ViewController.swift
//  NewsApp
//
//  Created by Joel on 3/7/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit
import SwiftyGif

class ViewController: UITabBarController {
    let logoAnimationUIView = LogoAnimationUIView()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(logoAnimationUIView)
        logoAnimationUIView.pinEdgesToSuperView()
        logoAnimationUIView.logoGifImageView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        logoAnimationUIView.logoGifImageView.startAnimatingGif()
    }
}

extension ViewController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        logoAnimationUIView.isHidden = true
    }
}
