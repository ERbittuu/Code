//
//  Array.swift
//  Code
//
//  Created by Utsav Patel on 7/5/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

extension Array where Element == InstagramScope {

    /// Returns a String constructed by joining the array elements with the given `separator`.
    func joined(separator: String) -> String {
        return self.map { "\($0.rawValue)" }.joined(separator: separator)
    }
}
