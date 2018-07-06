//
//  Utils.swift
//  Code
//
//  Created by Utsav Patel on 6/29/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: AnyObject]

extension String: Error {
}

func doInBackground(_ block: @escaping () -> ()) {
    DispatchQueue.global(qos: .default).async {
        block()
    }
}

func doOnMain(_ block: @escaping () -> ()) {
    DispatchQueue.main.async {
        block()
    }
}
