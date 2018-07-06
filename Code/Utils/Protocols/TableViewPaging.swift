//
//  TableViewPaging.swift
//  Code
//
//  Created by Utsav Patel on 7/6/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import Foundation

@objc public protocol TableViewPaging {
    
    @objc optional func didPaginate(_ tableView: TableView, to page: Int)
    func paginate(_ tableView: TableView, to page: Int)
    
}
