//
//  NTHMultiNavigationItem.swift
//  Nothing
//
//  Created by Tomasz Szulc on 14/03/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHMultiNavigationItem: UINavigationItem {
    
    @IBOutlet var leftBarButtonItemsCollection: [UIBarButtonItem]! {
        set { self.leftBarButtonItems = newValue }
        get { return self.leftBarButtonItems as! [UIBarButtonItem] }
    }
    
    @IBOutlet var rightBarButtonItemsCollection: [UIBarButtonItem]! {
        set { self.rightBarButtonItems = newValue }
        get { return self.rightBarButtonItems as! [UIBarButtonItem] }
    }
}

