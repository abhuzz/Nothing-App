//
//  WMView.swift
//  Nothing
//
//  Created by Tomasz Szulc on 28/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

extension WMKit {
    class WMView: UIView {
        var words: [WMWord] = [WMWord]()
        var font: UIFont = UIFont()
        
        init(size: CGSize, words: [WMWord], font: UIFont) {
            self.words = words
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
            for word in self.words {
                /// reset offset
                if (previousLine != word.line) {
                    previousLine = word.line
                    offsetX = 0
                }
                
                /// calculate rect
                let y = CGFloat(word.size.height * CGFloat(word.line))
                let rect = CGRectMake(offsetX, y, word.size.width, word.size.height)
                offsetX = rect.maxX
                
                /// add view and draw text
                let wordView = WMWordView(word: word, frame: rect)
                self.addSubview(wordView)
            }
        }
        
        /// Return word as `WMWordProxy` if found, otherwise nil
        func wordForPoint(point: CGPoint) -> WMWordProxy? {
            for view in self.subviews as [WMWordView] {
                if CGRectContainsPoint(view.frame, point) {
                    return WMWordProxy(view.word)
                }
            }
            
            return nil
        }
        
        /// Return snapshot of the view
        func snapshot() -> UIImage {
            for view in self.subviews as [WMWordView] {
                view.drawWord(self.font)
            }
            
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0)
            self.layer.renderInContext(UIGraphicsGetCurrentContext())
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
    }

    private class WMWordView: UIImageView {
        var word: WMWord
        init(word: WMWord, frame: CGRect) {
            self.word = word
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
            (word.text as NSString).drawInRect(self.bounds, withAttributes: attr)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.image = image
        }
    }
}

