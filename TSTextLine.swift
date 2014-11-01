//
//  TSTextLine.swift
//  Nothing
//
//  Created by Tomasz Szulc on 01/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import UIKit

/// internal type represents a line of text
class TSTextLine {
    var number = 0
    var range = NSMakeRange(0, 0)
    var texts = [TSText]()
    
    var textRefsStringRepresentation: String {
        var output = ""
        for text in self.texts {
            output += text.value
        }
        
        return output
    }
}

class TSTextLineGenerator {
    class func linesOfText(text: String, font: UIFont, viewSize: CGSize) -> [String] {

        let ctFont = CTFontCreateWithName(font.fontName, font.pointSize, nil)
        var attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(kCTFontAttributeName, value: ctFont, range: NSMakeRange(0, attrString.length))
        
        let framesetter = CTFramesetterCreateWithAttributedString(attrString)
        
        let path = CGPathCreateMutable()
        CGPathAddRect(path, nil, CGRect(x: 0, y: 0, width: viewSize.width, height: 100_000))
        
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        
        let lines = CTFrameGetLines(frame)
        var output = [String]()
        
        for line in lines as [CTLineRef] {
            let lineRange = CTLineGetStringRange(line)
            let range = NSMakeRange(lineRange.location, lineRange.length)
            
            output.append((text as NSString!).substringWithRange(range))
        }
        
        return output
    }
}


