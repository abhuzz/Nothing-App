//
//  UIAlertController_TS.swift
//  Nothing
//
//  Created by Tomasz Szulc on 22/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    class func actionSheet(title: String?, message: String?) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
    }
    
    class func alert(title: String, message: String?) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .Alert)
    }
}