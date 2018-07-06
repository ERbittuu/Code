//
//  AppDelegate.swift
//  Code
//
//  Created by Utsav Patel on 6/29/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import UIKit

// MARK: AppDelegate: UIResponder, UIApplicationDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Instance Variables
    
    var window: UIWindow?
    var app: AppDirector?
    
    // MARK: UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if let window = window {
            app = AppDirector(window: window)
        }
        
        return true
    }
    
    static let shared = UIApplication.shared.delegate as! AppDelegate
    
}
