//
//  UILabel_E.swift
//  Nothing
//
//  Created by Tomasz Szulc on 28/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    var proposedHeight: CGFloat {
        var sizeToFit = CGSize(width: self.bounds.size.width, height: CGFloat.max)
        return self.sizeThatFits(sizeToFit).height
    }
}

extension UITextView {
    var proposedHeight: CGFloat {
        if (self.text == "") {
            return 0
        }
        
        var sizeToFit = CGSize(width: self.bounds.size.width, height: CGFloat.max)
        return self.sizeThatFits(sizeToFit).height
    }
}