//
//  UIStoryboardSegue_TS.swift
//  Nothing
//
//  Created by Tomasz Szulc on 01/03/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboardSegue {
    var topOfNavigationController: UIViewController {
        return (self.destinationViewController as! UINavigationController).topViewController
    }
}