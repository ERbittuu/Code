//
//  Comment.swift
//  Code
//
//  Created by Utsav Patel on 7/4/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import UIKit

/// The struct containing an Instagram comment.
public struct InstagramComment: Decodable {

    // MARK: - Properties

    /// The comment identifier.
    public let id: String

    /// The comment text.
    public let text: String

    /// The date and time when the comment was created.
    public let createdDate: Date

    // MARK: - Types

    private enum CodingKeys: String, CodingKey {
        case id, text, createdTime
    }

    // MARK: - Initializers

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        text = try container.decode(String.self, forKey: .text)
        let createdTime = try container.decode(String.self, forKey: .createdTime)
        createdDate = Date(timeIntervalSince1970: Double(createdTime)!)
    }
}
