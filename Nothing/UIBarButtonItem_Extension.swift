//
//  UIBarButtonItem_Extension.swift
//  Nothing
//
//  Created by Tomasz Szulc on 26/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

extension UIBarButtonItem {

    class func backButton(target: AnyObject, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(title: "Close", style: .Plain, target: target, action: action)
//        return UIBarButtonItem(image: UIImage(named: "back"), style: UIBarButtonItemStyle.Plain, target: target, action: action)
    }
    
    class func saveButton(target: AnyObject, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(title: "Save", style: .Plain, target: target, action: action)
//        return UIBarButtonItem(image: UIImage(named: "confirm-enabled"), style: UIBarButtonItemStyle.Plain, target: target, action: action)
    }
    
    class func editButton(target: AnyObject, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(title: "Edit", style: .Plain, target: target, action: action)
    }
    
    class func changeStateButton(target: AnyObject, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(title: "Change State", style: .Plain, target: target, action: action)
    }
}