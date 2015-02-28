//
//  NTHSheetViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 24/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHSheetViewController: UIViewController {

    @IBOutlet var container: UIView!
    @IBOutlet var containerBottomConstraint: NSLayoutConstraint!
    
    @IBAction func handleBackgroundTap(sender: AnyObject) {
        self._unwind()
    }
    
    private func _unwind() {
        NTHUnwindSheetSegue(identifier: "CloseSheet", source: self, destination: self.presentingViewController as UIViewController!).perform()
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        self._unwind()
    }
}
