//
//  Endpoints.swift
//  Code
//
//  Created by Utsav Patel on 6/29/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import Foundation

public class Endpoints {
    
    private init() {}

    /// Get the most recent media published by a user.
    ///
    /// - parameter userId: The ID of the user whose recent media to retrieve, or "self" to reference the currently authenticated user.
    /// - parameter success: The callback called after a correct retrieval.
    /// - parameter failure: The callback called after an incorrect retrieval.
    ///
    /// - important: It requires *public_content* scope when getting recent media published by a user other than yours.
    public static func recentMedia(fromUser userId: String,
                            nextUrl: String? = nil,
                            success: @escaping Handler<PhotoResponse>) {

        print(nextUrl ?? "sa")
        if let nextUrl = nextUrl {
            Rest.prepare(HTTPMethod: .GET, url: nextUrl)
                .call { (decode, error) in
                    success(decode, error)
            }
        }else{
            Rest.prepare(HTTPMethod: .GET, url: Instagram.API.baseURL)
                .setURLParams(["users", userId, "media", "recent"])
                .setParams(["access_token": Instagram.shared.retrieveAccessToken() ?? ""])
                .call { (decode, error) in
                    success(decode, error)
            }
        }
       
    }    
    
    /// In complete
    public func comments(fromMediaId mediaId: String,
                            success: @escaping Handler<PhotoResponse>) {
        
        Rest.prepare(HTTPMethod: .GET, url: Instagram.API.baseURL)
            .setURLParams(["users", mediaId, "media", "recent"])
            .setParams(["access_token": Instagram.shared.retrieveAccessToken() ?? ""])
            .call { (decode, error) in
                success(decode, error)
        }
        
    }
    
}
