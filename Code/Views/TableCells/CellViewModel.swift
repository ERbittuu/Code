//
//  CellViewModel.swift
//  Code
//
//  Created by Utsav Patel on 6/29/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import UIKit

// MARK: AppTableCellViewModel

struct CellViewModel {
  var media: Media
}

// MARK: AppTableCellViewModel: ImagePresentable

extension CellViewModel: ImagePresentable {
    var likeCounts: Int {
        return media.likes.count
    }
    
    var commentCounts: Int {
        return media.likes.count
    }
    
    var imageURL: URL? {
    return media.images.standardResolution.url
    }

    var imageName: String? {
    return nil
    }
}
