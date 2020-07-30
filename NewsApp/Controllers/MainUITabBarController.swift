//
//  ViewController.swift
//  NewsApp
//
//  Created by Joel on 3/7/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit
import SwiftyGif

class MainUITabBarController: UITabBarController {
    let logoAnimationUIView = LogoAnimationUIView()
    var tabItems: [UITabBarItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabItems = self.tabBar.items
        
        //view.addSubview(logoAnimationUIView)
        //logoAnimationUIView.pinEdgesToSuperView()
        //logoAnimationUIView.logoGifImageView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //logoAnimationUIView.logoGifImageView.startAnimatingGif()
        if let items = self.tabBar.items {
            items.forEach {
                if (UserDataManager.loggedIn == nil && ($0.title == "Bookmarks" || $0.title == "Badges")) {
                    $0.isEnabled = false
                }
                else {
                    $0.isEnabled = true
                }
            }
        }
    }
}

extension MainUITabBarController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        logoAnimationUIView.isHidden = true
    }
}
