//
//  UIAlertAction_tomkowz.swift
//  Nothing
//
//  Created by Tomasz Szulc on 07/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

extension UIAlertAction {
    
    typealias UIAlertActionHandler = (UIAlertAction!) -> Void
    
    class func cancelAction(title: String!, handler: UIAlertActionHandler?) -> UIAlertAction {
        return UIAlertAction(title: title, style: .Cancel, handler: handler)
    }
    
    class func normalAction(title: String!, handler: UIAlertActionHandler?) -> UIAlertAction {
        return UIAlertAction(title: title, style: .Default, handler: handler)
    }
}