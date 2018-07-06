//
//  ImagePresentable.swift
//  Code
//
//  Created by Utsav Patel on 6/29/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import UIKit

protocol ImagePresentable {
    var likeCounts: Int { get }
    var commentCounts: Int { get }
    var imageURL: URL? { get }
}

extension ImagePresentable {
    var imageURL: URL? { return nil }
}
