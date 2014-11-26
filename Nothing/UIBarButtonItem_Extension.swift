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
        return UIBarButtonItem(image: UIImage(named: "back"), style: UIBarButtonItemStyle.Plain, target: target, action: action)
    }
    
    class func saveButton(target: AnyObject, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(named: "confirm-enabled"), style: UIBarButtonItemStyle.Plain, target: target, action: action)
    }
}