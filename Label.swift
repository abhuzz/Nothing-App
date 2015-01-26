//
//  Label.swift
//  Nothing
//
//  Created by Tomasz Szulc on 25/01/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class Label: UILabel {
    
    typealias LabelTapBlock = () -> Void
    var tapBlock: LabelTapBlock?
    
    private var _tapGesture: UITapGestureRecognizer!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        _tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        self.addGestureRecognizer(_tapGesture!)
    }
    
    internal func handleTap(recognizer: UITapGestureRecognizer) {
        if self.enabled == false { return }
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.alpha = 0.5
        }) { (flag) -> Void in
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.alpha = 1
            }, completion: { (flag) -> Void in
                self.tapBlock?()
                return /// avoid compiler warning.
            })
        }
    }
}
