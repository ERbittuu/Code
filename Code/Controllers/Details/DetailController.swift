//
//  DetailController.swift
//  Code
//
//  Created by Utsav Patel on 6/29/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import UIKit

class DetailController: UIViewController {

    var media: Media!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = media.caption?.text ?? "🤪"
        
        ImageDownloader.load(with: media.images.standardResolution.url, completion: { [weak self] in
            self?.imageView.image = $0
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
