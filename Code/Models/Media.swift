//
//  Media.swift
//  Code
//
//  Created by Utsav Patel on 7/4/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import Foundation
import CoreLocation

public struct PhotoResponse: Decodable {
    
    // MARK: - Properties
    
    var data: [Media]?
    var meta: Meta
    var pagination: Pagination?
    
    // MARK: - Types
    
    struct Meta: Decodable {
        let code: Int
        let errorType: String?
        let errorMessage: String?
    }
    
    struct Pagination: Decodable {
        let nextUrl: String?
        let nextMaxId: String?
    }
}

/// The struct containing an Instagram media.
public struct Media: Decodable {
    
    // MARK: - Properties
    
    /// The media identifier.
    public let id: String
    
    /// The date and time when the media was created.
    public let createdDate: Date
    
    /// The type of media. It can be "image" or "video".
    public let type: String
    
    /// The thumbnail, low and standard resolution images of the media.
    public let images: Images
    
    /// The headline of the media.
    public let caption: InstagramComment?
    
    /// A Count object that contains the number of comments on the media.
    public let comments: Count
    
    /// A Count object that contains the number of likes on the media.
    public let likes: Count
    
    /// A list of tags used in the media.
    public let tags: [String]
    
    // MARK: - Types
    
    /// A struct cointaing the number of elements.
    public struct Count: Decodable {
        
        /// The number of elements.
        public let count: Int
    }
    
    /// A struct containing the resolution of a video or image.
    public struct Resolution: Decodable {
        
        /// The width of the media.
        public let width: Int
        
        /// The height of the media.
        public let height: Int
        
        /// The URL to download the media.
        public let url: URL
    }
    
    /// A struct cointaining the thumbnail, low and high resolution images of the media.
    public struct Images: Decodable {
        
        /// A Resolution object that contains the width, height and URL of the thumbnail.
        public let thumbnail: Resolution
        
        /// A Resolution object that contains the width, height and URL of the low resolution image.
        public let lowResolution: Resolution
        
        /// A Resolution object that contains the width, height and URL of the standard resolution image.
        public let standardResolution: Resolution
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, createdTime, type, images, caption, comments, likes, tags
    }
    
    // MARK: - Initializers
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        let createdTime = try container.decode(String.self, forKey: .createdTime)
        createdDate = Date(timeIntervalSince1970: Double(createdTime)!)
        type = try container.decode(String.self, forKey: .type)
        images = try container.decode(Images.self, forKey: .images)
        caption = try container.decodeIfPresent(InstagramComment.self, forKey: .caption)
        comments = try container.decode(Count.self, forKey: .comments)
        likes = try container.decode(Count.self, forKey: .likes)
        tags = try container.decode([String].self, forKey: .tags)
    }
}
