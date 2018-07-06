//
//  ImageDownloader.swift
//  Code
//
//  Created by Utsav Patel on 6/29/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import UIKit

class ImageDownloader {
  
    private init() {}
  
    static let dir : String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory,
                                                         FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    
    static func load(with url: URL, completion: @escaping (_ image: UIImage?) -> ()) {

    let path = ImageDownloader.dir + "/" + url.lastPathComponent

    if FileManager.default.fileExists(atPath: path) {
        doInBackground {
            if let data = FileManager.default.contents(atPath: path) {
                if let img =  UIImage(data: data, scale: 1) {
                    doOnMain {
                        completion(img)
                    }
                    return
                }
            }
        }
    }

    URLSession.shared.dataTask(with: url) { (data, _, _) in
        let image = data.flatMap { UIImage(data: $0) }
        doOnMain {
            completion(image)
        }
        doInBackground {
            if let img = image {
                try? UIImagePNGRepresentation(img)?.write(to: URL(fileURLWithPath: path))
            }
        }
    }.resume()
    }
  
}
