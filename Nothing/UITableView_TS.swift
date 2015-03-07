//
//  UITableView_TS.swift
//  Nothing
//
//  Created by Tomasz Szulc on 15/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func registerNibWithName(name: String!, identifier: String!) {
        self.registerNib(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    func registerNib(name: String!) {
        self.registerNibWithName(name, identifier: name)
    }
    
    func refreshTableView(heightConstraint: NSLayoutConstraint, height: CGFloat) {
        heightConstraint.constant = height
        UIView.animateWithDuration(NSTimeInterval(0.3), animations: {
            self.needsUpdateConstraints()
            self.reloadData()
            return /// explicit return
        })
    }
}