//
//  NTHSheetSegue.swift
//  Nothing
//
//  Created by Tomasz Szulc on 24/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHSheetSegue: UIStoryboardSegue {
   
    override func perform() {
        let sourceVC = self.sourceViewController as! UIViewController
        let destinationVC = self.destinationViewController as! NTHSheetViewController
        destinationVC.view.alpha = 0
        let window = UIApplication.sharedApplication().keyWindow!
        
        /// This also loads the `view`.
        window.addSubview(destinationVC.view)

        /// Move container to the bottom of the view
        destinationVC.containerBottomConstraint.constant = -destinationVC.container.frame.height
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            destinationVC.view.alpha = 1
        }) { (finished1) -> Void in
            destinationVC.containerBottomConstraint.constant = 0
            UIView.animateWithDuration(NSTimeInterval(0.25), delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                
                destinationVC.container.layoutIfNeeded()
                }) { (finished2) -> Void in
                    destinationVC.view.removeFromSuperview()
                    sourceVC.presentViewController(destinationVC, animated: false, completion: nil)
            }
        }
    }
    
}
