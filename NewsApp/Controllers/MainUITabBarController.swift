//
//  ViewController.swift
//  NewsApp
//
//  Created by Joel on 3/7/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit
import SwiftyGif

class MainUITabBarController: UITabBarController, UITabBarControllerDelegate {
    private let logoAnimationUIView = LogoAnimationUIView()
    private var tabItems: [UITabBarItem]?
    private var vcs: [UIViewController]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabItems = self.tabBar.items
        self.vcs = [
            storyboard!.instantiateViewController(withIdentifier: "BookmarksNavigation"),
            storyboard!.instantiateViewController(withIdentifier: "BadgesNavigation")
        ]
        
        vcs?[0].tabBarItem = tabItems?[3]
        vcs?[1].tabBarItem = tabItems?[4]
        
        view.addSubview(logoAnimationUIView)
        logoAnimationUIView.pinEdgesToSuperView()
        logoAnimationUIView.logoGifImageView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        logoAnimationUIView.logoGifImageView.startAnimatingGif()
        
        UserDataManager.shared.delegate = self
        updateTabItems()
    }
    
    func updateTabItems() {
        if tabItems != nil && vcs != nil {
            if UserDataManager.loggedIn == nil && self.viewControllers?.count ?? 0 > 4 {
                self.viewControllers?.removeLast(2)
            }
            else if self.viewControllers?.count ?? 0 < 5 {
                self.viewControllers?.append(contentsOf: vcs!)
            }
        }
    }
}

extension MainUITabBarController: UserManagerDelegate {
    func loggedInDidChange(newVal: User?) {
        updateTabItems()
    }
}

extension MainUITabBarController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        logoAnimationUIView.isHidden = true
    }
}
