//
//  UINetImageView.swift
//  GithubJobApp
//
//  Created by Daniel Harrison on 12/1/16.
//  Copyright © 2016 Taylor Harrison. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func setImgFromUrl(url: NSURL) {
        if let image = NetImageCache.cache.objectForKey(url) as? UIImage {
            print("using cached image")
            self.image = image
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.image = UIImage(named: "logo_placeholder")
                    let task = NSURLSession.sharedSession().dataTaskWithURL(url) {data, _, error in
                        if error == nil {
                            if let data = data, logoImage = UIImage(data: data) {
                                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                                    self.image = logoImage
                                    NetImageCache.cache.setObject(logoImage, forKey: url as AnyObject)
                                }
                            }
                        }
                    }
                    task.resume()
                }
            }
            
        }
    }
}

struct NetImageCache {
    static let cache = NSCache()
}

