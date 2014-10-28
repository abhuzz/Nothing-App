//
//  WMView.swift
//  Nothing
//
//  Created by Tomasz Szulc on 28/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

class WMView: UIView {
    let size: CGSize = CGSizeZero
    var words: [WMWord] = [WMWord]()
    var font: UIFont = UIFont()
    
    init(size: CGSize, words: [WMWord], font: UIFont) {
        self.size = size
        self.words = words
        self.font = font
        super.init(frame: CGRectMake(0, 0, self.size.width, self.size.height))
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func prepare() {
        var offsetX: CGFloat = 0.0
        var lastLine: Int = 0
        for word in self.words {
            /// reset offset
            if (lastLine != word.line) {
                lastLine = word.line
                offsetX = 0
            }
            
            /// calculate rect
            let y = CGFloat(word.size.height * CGFloat(word.line))
            let rect = CGRectMake(offsetX, y, word.size.width, word.size.height)
            offsetX = rect.maxX
            
            /// add view and draw text
            let wordView = WMWordView(word: word, frame: rect, font: self.font)
            wordView.drawWord()
            self.addSubview(wordView)
        }
    }
    
    func wordForPoint(point: CGPoint) -> WMWord? {
        for view in self.subviews as [WMWordView] {
            if CGRectContainsPoint(view.frame, point) {
                return view.word
            }
        }
        
        return nil
    }
    
    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0)
        self.layer.renderInContext(UIGraphicsGetCurrentContext())
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}

private class WMWordView: UIImageView {
    var word: WMWord
    var font: UIFont
    init(word: WMWord, frame: CGRect, font: UIFont) {
        self.word = word
        self.font = font
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawWord() {
        let attr = [
            NSFontAttributeName: self.font,
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSBackgroundColorAttributeName: UIColor(white: 0.7, alpha: 1.0)
        ]
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0)
        (word.text as NSString).drawInRect(self.bounds, withAttributes: attr)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.image = image
    }
}

