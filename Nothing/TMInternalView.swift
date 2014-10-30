//
//  WMView.swift
//  Nothing
//
//  Created by Tomasz Szulc on 28/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

class WMInternaliew: UIView {
    var texts: [TMText] = [TMText]()
    var font: UIFont = UIFont()
    
    init(size: CGSize, texts: [TMText], font: UIFont) {
        self.texts = texts
        self.font = font
        super.init(frame: CGRectMake(0, 0, size.width, size.height))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Call method before `wordForPoint:`.
    func prepare() {
        var offsetX: CGFloat = 0.0
        var previousLine: Int = 0
        
        // Enumerate texts, calculate rect, create view and draw text in created view
        for text in self.texts {
            /// reset offset
            let tappableTextLine = text.line
            if (previousLine != tappableTextLine) {
                previousLine = tappableTextLine
                offsetX = 0
            }
            
            /// calculate rect
            let y = CGFloat(text.size.height * CGFloat(text.line))
            let rect = CGRectMake(offsetX, y, text.size.width, text.size.height)
            offsetX = rect.maxX
            
            /// add view and draw text
            let wordView = TMInternalTextView(text: text, frame: rect)
            wordView.backgroundColor = UIColor.blueColor()
            self.addSubview(wordView)
        }
    }
    
    /// Return text as `WMWordProxy` if found, otherwise nil
    func textForPoint(point: CGPoint) -> TMText? {
        for view in self.subviews as [TMInternalTextView] {
            if CGRectContainsPoint(view.frame, point) {
                return view.text
            }
        }
        
        return nil
    }
    
    /// Return snapshot of the view
    func snapshot() -> UIImage {
        for view in self.subviews as [TMInternalTextView] {
            view.drawWord(self.font)
        }
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0)
        self.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

private class TMInternalTextView: UIImageView {
    var text: TMText
    init(text: TMText, frame: CGRect) {
        self.text = text
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var isDrawn = false
    func drawWord(font: UIFont) {
        /// check if already drawn
        if self.isDrawn {
            return
        }
        
        self.isDrawn = true
        /// create attributes
        let attr = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSBackgroundColorAttributeName: UIColor(white: 0.7, alpha: 1.0)
        ]
        
        /// draw text
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0)
        (self.text.ref.value as NSString).drawInRect(self.bounds, withAttributes: attr)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.image = image
    }
}

