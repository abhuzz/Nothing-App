//
//  WMView.swift
//  Nothing
//
//  Created by Tomasz Szulc on 28/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

class WMInternaliew: UIView {
    var texts: [WMTappableText] = [WMTappableText]()
    var font: UIFont = UIFont()
    
    init(size: CGSize, texts: [WMTappableText], font: UIFont) {
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
        
        // Enumerate words, calculate rect, create view and draw word in created view
        for tappableText in self.texts {
            /// reset offset
            let tappableTextLine = tappableText.text.line
            if (previousLine != tappableTextLine) {
                previousLine = tappableTextLine
                offsetX = 0
            }
            
            /// calculate rect
            let y = CGFloat(tappableText.text.size.height * CGFloat(tappableText.text.line))
            let rect = CGRectMake(offsetX, y, tappableText.text.size.width, tappableText.text.size.height)
            offsetX = rect.maxX
            
            /// add view and draw text
            let wordView = WMTappableTextView(tappableText: tappableText, frame: rect)
            wordView.backgroundColor = UIColor.blueColor()
            self.addSubview(wordView)
        }
    }
    
    /// Return word as `WMWordProxy` if found, otherwise nil
    func wordForPoint(point: CGPoint) -> WMWordProxy? {
        for view in self.subviews as [WMTappableTextView] {
            if CGRectContainsPoint(view.frame, point) && view.tappableText.tappable {
                return WMWordProxy(view.tappableText)
            }
        }
        
        return nil
    }
    
    /// Return snapshot of the view
    func snapshot() -> UIImage {
        for view in self.subviews as [WMTappableTextView] {
            view.drawWord(self.font)
        }
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0)
        self.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

private class WMTappableTextView: UIImageView {
    var tappableText: WMTappableText
    init(tappableText: WMTappableText, frame: CGRect) {
        self.tappableText = tappableText
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
        
        /// draw word
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0)
        (tappableText.text.ref.value as NSString).drawInRect(self.bounds, withAttributes: attr)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.image = image
    }
}

