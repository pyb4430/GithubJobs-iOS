//
//  UINetImageView.swift
//  GithubJobApp
//
//  Created by Daniel Harrison on 12/1/16.
//  Copyright © 2016 Taylor Harrison. All rights reserved.
//

import Foundation
import UIKit

class UINetImageView: UIImageView {
    
    static let netImageCache = NSCache()
    
    func setImgFromUrl(url: String) {
        if let imgUrl = NSURL(string: url) {
            let task = NSURLSession.sharedSession().dataTaskWithURL(imgUrl) {(data, response, error) in
                if error == nil {
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        if let data = data, logoImage = UIImage(data: data) {
                            self.image = logoImage
                            UINetImageView.netImageCache.setObject(logoImage, forKey: url as AnyObject)
                        }
                    }
                } else {
                    if let error = error { print("error: \(error) \n") }
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        self.image = UIImage(named: "logo_placeholder")
                    }
                }
            }
            task.resume()
        }
    }
}

