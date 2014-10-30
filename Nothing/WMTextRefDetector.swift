//
//  WMTextRefManager.swift
//  Nothing
//
//  Created by Tomasz Szulc on 29/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation

protocol WMTextRef {
    var value: String {get set}
    var range: NSRange {get set}
}

struct WMWhitespaceRef: WMTextRef {
    var value: String
    var range: NSRange
}

struct WMWordRef: WMTextRef {
    var value: String
    var range: NSRange
}

class WMTextRefDetector {
    class func textRefs(text: String) -> [WMTextRef] {
        var wordStart: Int = 0
        var wordEnd: Int = 0
        var wordStarted = false
        
        /// get words and white spaces
        var refs = [WMTextRef]()
        for idx in 0..<countElements(text) {
            let index = advance(text.startIndex, idx)
            let character = text.substringWithRange(Range(start: index, end: index.successor()))
            let trimmedCharacter = (character as NSString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            if countElements(trimmedCharacter) > 0 {
                if !wordStarted {
                    wordStarted = true
                    wordStart = idx
                } else {
                    wordEnd = idx+1
                }
            } else {
                if wordStarted {
                    wordStarted = false
                    
                    var range = NSMakeRange(wordStart, (wordEnd - wordStart > 0) ? wordEnd - wordStart : 1)
                    let str = (text as NSString).substringWithRange(range)
                    refs.append(WMWordRef(value: str, range: range))
                    refs.append(WMWhitespaceRef(value: character, range: NSMakeRange(idx, 1)))
                }
            }
            
            if idx == countElements(text) - 1 {
                wordEnd = idx+1
                wordStarted = false
                let range = NSMakeRange(wordStart, wordEnd - wordStart)
                let str = (text as NSString).substringWithRange(range)
                refs.append(WMWordRef(value: str, range: range))
            }
        }
        
//        self.debug(refs)
        return refs
    }
    
    private class func debug(refs: [WMTextRef]) {
        var fullString = ""
        for ref in refs {
            fullString += ref.value
        }
        
        println(fullString)
    }
}
