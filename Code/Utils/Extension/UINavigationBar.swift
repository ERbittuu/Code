//
//  UINavigationBar.swift
//  Code
//
//  Created by Utsav Patel on 7/3/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import UIKit

enum NavButton {
    case profile
    case logout
    
    var type: UIBarButtonSystemItem {
        switch self {
            case .profile:
                return .add
            case .logout:
                return .trash
        }
    }
}

/// Typealias for UIBarButtonItem closure.
typealias UIBarButtonItemTargetClosure = (UIBarButtonItem) -> ()

class UIBarButtonItemClosureWrapper: NSObject {
    let closure: UIBarButtonItemTargetClosure
    init(_ closure: @escaping UIBarButtonItemTargetClosure) {
        self.closure = closure
    }
}

extension UIBarButtonItem {
    
    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }
    
    private var targetClosure: UIBarButtonItemTargetClosure? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? UIBarButtonItemClosureWrapper else { return nil }
            return closureWrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, UIBarButtonItemClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    convenience init(style: UIBarButtonSystemItem, closure: @escaping UIBarButtonItemTargetClosure) {
        self.init(barButtonSystemItem: style, target: nil, action: nil)
        targetClosure = closure
        action = #selector(UIBarButtonItem.closureAction)
    }
    
    @objc func closureAction() {
        guard let targetClosure = targetClosure else { return }
        targetClosure(self)
    }
    
}

extension UINavigationItem {

    func addbutton(onRight: Bool, type: NavButton, action: @escaping ((UIBarButtonItem) -> ())){

        let button = UIBarButtonItem(style: type.type, closure: action)
        
        if onRight {
            self.rightBarButtonItem = button
        }else{
            self.leftBarButtonItem = button
        }
    }
    
    func removeButton(onRight: Bool){
        
        if onRight {
            self.rightBarButtonItem = nil
        }else{
            self.leftBarButtonItem = nil
        }
    }
    
}
