//
//  Label.swift
//  Nothing
//
//  Created by Tomasz Szulc on 25/01/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

typealias LabelTapBlock = () -> Void

class Label: UILabel {
    
    var onTap: LabelTapBlock?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
    }
    
    internal func handleTap(recognizer: UITapGestureRecognizer) {
        if self.enabled == false { return }
        
        UIView.animateWithDuration(0.2, animations: { [unowned self] in
            self.alpha = 0.5
        }) { (flag) -> Void in
            UIView.animateWithDuration(0.1, animations: { [unowned self] in
                self.alpha = 1
            }, completion: { (flag) -> Void in
                self.onTap?()
                return /// avoid compiler warning.
            })
        }
    }
}
