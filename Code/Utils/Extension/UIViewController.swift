//
//  UIViewController.swift
//  Code
//
//  Created by Utsav Patel on 7/3/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func largeTitle(text: String? = nil) {
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.topItem?.title = text
            navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        } else {
            // Fallback on earlier versions
            navigationController?.navigationBar.topItem?.title = text
        }
    }

    
    func searchBar(shows: Bool) {
        
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = UISearchController(searchResultsController: nil)
        } else {
            self.navigationItem.searchController = nil
            // Fallback on earlier versions
        }
    }
    
}
