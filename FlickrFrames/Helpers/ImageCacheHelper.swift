//
//  ImageCacheHelper.swift
//  FlickrFrames
//
//  Created by Vinayak Parmar on 02/09/18.
//  Copyright © 2018 VMP. All rights reserved.
//

import UIKit

class ImageCacheHelper: NSObject {
    private static var imageCache = NSCache<NSString, AnyObject>()
    
    class func resetCache() {
        imageCache.removeAllObjects()
    }
    
    class func cache(image: UIImage, forURL url: URL?) {
        if let urlString = url?.absoluteString as NSString? {
            imageCache.setObject(image, forKey: urlString)
        }
    }
    
    class func checkIfImageFoundFor(url: URL) -> UIImage? {
        if let urlString = url.absoluteString as NSString? {
            return imageCache.object(forKey: urlString) as? UIImage
        }
    }
}

extension UIImageView {
    func loadImageUsingCacheWith(imgURL: URL,
                                 onComplete:(() -> ())? = nil) -> URLSessionTask? {
        self.image = nil
        
        // check cached image
        if let cachedImage = ImageCacheHelper.checkIfImageFoundFor(url: imgURL) {
            self.image = cachedImage
            onComplete?()
            return nil
        }
        
        // if not, download image from url
        let task = URLSession.shared.dataTask(with: imgURL,
                                              completionHandler: { (data, response, error) in
                                                if error != nil {
                                                    return
                                                }
                                                
                                                if let image = UIImage(data: data!) {
                                                    DispatchQueue.main.async {
                                                        ImageCacheHelper.cache(image: image, forURL: imgURL)
                                                        self.image = image
                                                        
                                                        onComplete?()
                                                    }
                                                }
        })
        task.resume()
        return task
    }
}
