//
//  HelperExtensions.swift
//  NewsApp
//
//  Created by Joel on 5/8/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit

public extension UIViewController {
    // Present alert with spinning spinner
    func presentSpinnerAlert(title: String? = nil, message: String) -> Void {
        let loadAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating();

        loadAlert.view.addSubview(loadingIndicator)
        self.present(loadAlert, animated: false, completion: nil)
    }
}

// Load image from url async
public extension UIImageView {
    func loadFromUrl(defaultImgName: String, withUrl urlString: String) {
        let imageCache = NSCache<NSString, AnyObject>()
        let url = URL(string: urlString)
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }

        URLSession.shared.dataTask(with: url!, completionHandler: {
            data, res, err in
            
            if err != nil {
                self.image = UIImage(named: defaultImgName)
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                }
            }
        }).resume()
    }
}
