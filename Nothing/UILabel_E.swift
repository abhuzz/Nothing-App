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
    
    class Attributes {
        var font: UIFont?
        var textColor: UIColor?
        var numberOfLines: Int?
        
        init() {}
    }
    
    var proposedHeight: CGFloat {
        return self.sizeThatFits(CGSize(width: CGRectGetWidth(self.bounds), height: CGFloat.max)).height
    }
    
    func update(attr: Attributes) {
        if let font = attr.font { self.font = font }
        if let textColor = attr.textColor { self.textColor = textColor }
        if let numberOfLines = attr.numberOfLines { self.numberOfLines = numberOfLines }
    }
}