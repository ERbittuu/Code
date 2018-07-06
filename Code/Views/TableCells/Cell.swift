//
//  Cell.swift
//  Code
//
//  Created by Utsav Patel on 6/29/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {
  
    @IBOutlet weak var instaImageView: UIImageView!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var commentsCount: UILabel!
    
  // MARK: Variables
    
    static let reuseIdentifier = "Cell"

    override func prepareForReuse() {
    super.prepareForReuse()
        instaImageView.image = nil
    }

    // MARK: Public

    func configure(withDelegate delegate: CellViewModel, row: Int) {
        if let imageURL = delegate.imageURL {
          ImageDownloader.load(with: imageURL, completion: { [weak self] in
            if row == row {
                self?.instaImageView.image = $0
            }
          })
        }

        likeCount.text = delegate.likeCounts == 0 ? "" : "\(delegate.likeCounts) ❤️"
        commentsCount.text = delegate.commentCounts == 0 ? "" : " \(delegate.commentCounts) 💬"
    }
}
