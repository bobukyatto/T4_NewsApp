//
//  LogoAnimationUIView.swift
//  NewsApp
//
//  Created by Joel on 3/7/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit

class LogoAnimationUIView: UIView {
    let logoGifImageView: UIImageView = {
        guard let gifImage = try? UIImage(gifName: "animated-logo.gif") else {
            return UIImageView()
        }
        
        return UIImageView(gifImage: gifImage, loopCount: 1)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }

    private func commonInit() {
        backgroundColor = UIColor(red: 54.0 / 255.0, green: 98.0 / 255.0, blue: 123.0 / 255.0, alpha: 1)
        addSubview(logoGifImageView)
        logoGifImageView.translatesAutoresizingMaskIntoConstraints = false
        logoGifImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoGifImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        logoGifImageView.widthAnchor.constraint(equalToConstant: 374).isActive = true
        logoGifImageView.heightAnchor.constraint(equalToConstant: 65).isActive = true
    }
}
