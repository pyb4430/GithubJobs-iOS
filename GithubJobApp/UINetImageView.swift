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
    
    func setImgFromUrl(url: NSURL?) {
        guard let url = url, rawUrl = url.path else {
            setPlaceholder(){}
            return
        }
        if let image = NetImageCache.cache.objectForKey(rawUrl) as? UIImage {
            print("using cached image")
            self.image = image
        } else {
            setPlaceholder() {
                    let task = NSURLSession.sharedSession().dataTaskWithURL(url) {data, _, error in
                        if error == nil {
                            if let data = data, logoImage = UIImage(data: data) {
                                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                                    self.image = logoImage
                                    NetImageCache.cache.setObject(logoImage, forKey: rawUrl as AnyObject)
                                }
                            }
                        } else {
                            print("error loading image: \(error?.domain) \(error?.code)")
                        }
                    }
                    task.resume()
            }
        }
    }
    
    func setPlaceholder(completion: () -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let uiImage = UIImage(named: "logo_placeholder")
            dispatch_async(dispatch_get_main_queue()) {
                self.image = uiImage
                completion()
            }
        }
    }
}

enum NetImageCache {
    static let cache = NSCache()
}

