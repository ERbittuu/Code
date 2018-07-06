//
//  UIAlertController.swift
//  Code
//
//  Created by Utsav Patel on 7/5/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func showAlert( _ message: String, on vc: UIViewController) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}



