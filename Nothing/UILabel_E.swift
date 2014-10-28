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

extension UILabel {
    func characterIndexAtPoint(var point: CGPoint) -> CFIndex? {
        let optimizedAttributedText = self.attributedText.copy() as NSAttributedString
    
        
        let textRect = self.textRect
        if !CGRectContainsPoint(textRect, point) {
            return nil
        }
        
        point = CGPoint(x: point.x - textRect.origin.x, y: point.y - textRect.origin.y)
        point = CGPoint(x: point.x, y: CGRectGetHeight(textRect) - point.y)
        
        /// jak rozpoznac ktora literka jest kliknieta?
        /// https://github.com/petrpavlik/PPLabel/blob/master/PPLabel/PPLabel.m
        
        return 0
    }
    
    var textRect: CGRect {
        var textRect = self.textRectForBounds(self.bounds, limitedToNumberOfLines: self.numberOfLines)
        textRect.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(textRect)) / 2.0
        
        if self.textAlignment == .Center {
            textRect.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(textRect)) / 2.0
        }
        
        if self.textAlignment == .Right {
            textRect.origin.x = CGRectGetWidth(self.bounds) - CGRectGetWidth(textRect)
        }
        
        return textRect
    }
}