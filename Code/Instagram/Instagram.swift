//
//  Instagram.swift
//  Code
//
//  Created by Utsav Patel on 7/5/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import UIKit

/// A set of helper functions to make the Instagram API easier to use.
public class Instagram {

    // MARK: - Types

    /// Empty success handler
    public typealias EmptySuccessHandler = () -> Void

    /// Success handler
    public typealias SuccessHandler<T> = (_ data: T) -> Void

    /// Failure handler
    public typealias FailureHandler = (_ error: Error) -> Void

    enum API {
        static let authURL = "https://api.instagram.com/oauth/authorize"
        static let baseURL = "https://api.instagram.com/v1/"
    }

    private enum Keychain {
        static let accessTokenKey = "AccessToken"
    }

    enum HTTPMethod: String {
        case get = "GET", post = "POST", delete = "DELETE"
    }

    // MARK: - Properties

    private let urlSession = URLSession(configuration: .default)
    private let keychain = KeychainSwift(keyPrefix: "SwiftInstagram_")

    private var client: (id: String?, redirectURI: String?)?

    // MARK: - Initializers

    /// Returns a shared instance of Instagram.
    public static let shared = Instagram()

    private init() {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            let clientId = dict["InstagramClientId"] as? String
            let redirectURI = dict["InstagramRedirectURI"] as? String
            client = (clientId, redirectURI)
        }
    }

    // MARK: - Authentication

    /// Starts an authentication process.
    ///
    /// Shows a custom `UIViewController` with Intagram's login page.
    ///
    /// - parameter controller: The `UINavigationController` from which the `InstagramLoginViewController` will be showed.
    /// - parameter scopes: The scope of the access you are requesting from the user. Basic access by default.
    /// - parameter success: The callback called after a correct login.
    /// - parameter failure: The callback called after an incorrect login.
    public func login(from controller: UINavigationController,
                      withScopes scopes: [InstagramScope] = [.basic],
                      success: EmptySuccessHandler?,
                      failure: FailureHandler?) {

        guard client != nil else { failure?(InstagramError.missingClientIdOrRedirectURI); return }

        let authURL = buildAuthURL(scopes: scopes)

        let vc = InstagramLoginViewController(authURL: authURL, success: { accessToken in
            guard self.storeAccessToken(accessToken) else {
                failure?(InstagramError.keychainError(code: self.keychain.lastResultCode))
                return
            }

            controller.popViewController(animated: true)
            success?()
        }, failure: failure)

        controller.show(vc, sender: nil)
    }

    private func buildAuthURL(scopes: [InstagramScope]) -> URL {
        var components = URLComponents(string: API.authURL)!

        components.queryItems = [
            URLQueryItem(name: "client_id", value: client!.id),
            URLQueryItem(name: "redirect_uri", value: client!.redirectURI),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "scope", value: scopes.joined(separator: "+"))
        ]

        return components.url!
    }

    /// Ends the current session.
    ///
    /// - returns: True if the user was successfully logged out, false otherwise.
    @discardableResult
    public func logout() -> Bool {
        return deleteAccessToken()
    }

    /// Returns whether a user is currently authenticated or not.
    public var isAuthenticated: Bool {
        return retrieveAccessToken() != nil
    }

    // MARK: - Access Token

    /// Store your own authenticated access token so you don't have to use the included login authentication.
    public func storeAccessToken(_ accessToken: String) -> Bool {
        return keychain.set(accessToken, forKey: Keychain.accessTokenKey)
    }

    /// Returns the current access token.
    public func retrieveAccessToken() -> String? {
        return keychain.get(Keychain.accessTokenKey)
    }

    private func deleteAccessToken() -> Bool {
        return keychain.delete(Keychain.accessTokenKey)
    }
}

/// A type representing an error value that can be thrown.
public enum InstagramError: Error {
    
    /// Error 400 on login
    case badRequest
    
    /// Error decoding JSON
    case decoding(message: String)
    
    /// Invalid API request
    case invalidRequest(message: String)
    
    /// Keychain error
    case keychainError(code: OSStatus)
    
    /// The client id or the redirect URI is missing inside the Info.plist file
    case missingClientIdOrRedirectURI
}

/// Login permissions ([scopes](https://www.instagram.com/developer/authorization/)) currently supported by Instagram.
public enum InstagramScope: String {
    
    /// To read a user’s profile info and media.
    case basic
}
