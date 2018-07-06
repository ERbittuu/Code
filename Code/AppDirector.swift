//
//  AppDirector.swift
//  Code
//
//  Created by Utsav Patel on 6/29/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import UIKit

class AppDirector {
  
    // MARK: Inastance Variables
  
    public let window: UIWindow
    private let storyboard = UIStoryboard(name: "Main", bundle: nil)
    private let navigationController: UINavigationController
  
    // MARK: Init

    init(window: UIWindow) {
        self.window = window
        self.navigationController = window.rootViewController as! UINavigationController
        configure()
    }

    // MARK: Private

    private func configure() {

        self.sharedUI()
        
        let appsVC = storyboard.instantiateViewController(withIdentifier: "HomeController") as! HomeController
        appsVC.didSelect = showMedia

        navigationController.viewControllers = [appsVC]
    }
    
    private func showMedia(_ media: Media) {
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailController") as! DetailController
        detailVC.media = media
        navigationController.pushViewController(detailVC, animated: true)
    }
    
    func sharedUI(){
        self.window.tintColor = UIColor.init(red: 225.0 / 225.0, green: 48.0 / 225.0, blue: 108.0 / 225.0, alpha: 1)
    }
}
