//
//  NTHUnwindSheetSegue.swift
//  Nothing
//
//  Created by Tomasz Szulc on 24/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHUnwindSheetSegue: UIStoryboardSegue {
    
    override func perform() {
        let sourceVC = self.sourceViewController as! NTHSheetViewController
        let destinationVC = self.destinationViewController as! UIViewController
        
        sourceVC.containerBottomConstraint.constant = -sourceVC.container.frame.height
        UIView.animateWithDuration(NSTimeInterval(0.15), delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            sourceVC.view.alpha = 0
            sourceVC.container.layoutIfNeeded()
            }) { (finished) -> Void in
                sourceVC.dismissViewControllerAnimated(false, completion: nil)
        }
    }
}

