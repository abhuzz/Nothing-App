//
//  TappableLabelController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 28/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import UIKit
    
class WordMapper {
    private let font: UIFont
    private let viewSize: CGSize
    private var words: [WMWord] = [WMWord]()
    private var view: WMView?
    
    init(font: UIFont, viewSize: CGSize) {
        self.font = font
        self.viewSize = viewSize
    }
    
    private func sizeForText(text: NSString) -> CGSize {
        var size = text.boundingRectWithSize(self.viewSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.font], context: nil).size
        
        var label = UILabel(frame: CGRectZero)
        label.font = self.font
        label.text = text
        label.sizeToFit()
        var proposed = label.bounds.size
//        println("size = \(size), proposed = \(proposed)")
        
        return proposed
    }
    
    func mapWordsSeparatedByWhiteSpaceAndNewLineCharacterSet(text: String) {
        var words = [WMWord]()
        for line in self.mapLines(text) {
            for ref in line.refs {
                words.append(WMWord(text: ref.value,
                                    size: sizeForText(ref.value),
                                    line: line.number,
                                tappable: (ref is WMWordRef)))
            }
        }
        
        self.words = words
        self.debug()
    }
    
    func mapWordsUsingRanges(ranges: [WMWordRange], text: String) {
        
        var words = [WMWord]()
        for line in self.mapLines(text) {
            for ref in line.refs {
                
                var tappable = false
                for range in ranges {
                    tappable = ref.range == range
                    if (tappable) {
                        break
                    }
                }
                
                words.append(WMWord(text: ref.value,
                    size: sizeForText(ref.value),
                    line: line.number,
                    tappable: tappable))
            }
        }
        
        self.words = words
        self.debug()
    }
    
    private func textRefs(text: String) -> [WMTextRef] {
        var wordStart: Int = 0
        var wordEnd: Int = 0
        var wordStarted = false
        
        /// get words and white spaces
        var textRefs = [WMTextRef]()
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
                    textRefs.append(WMWordRef(value: str, range: range))
                    textRefs.append(WMWhitespaceRef(value: character, range: NSMakeRange(idx, 1)))
                }
            }
            
            if idx == countElements(text) - 1 {
                wordEnd = idx+1
                wordStarted = false
                let range = NSMakeRange(wordStart, wordEnd - wordStart)
                let str = (text as NSString).substringWithRange(range)
                textRefs.append(WMWordRef(value: str, range: range))
            }
        }
        
        /// debug
        var fullString = ""
        for word in textRefs {
            fullString += word.value
        }
        
        println(fullString)

        return textRefs
    }
    
    private func mapLines(text: String) -> [WMLine] {
        
        var lines = [WMLine]()
        
        var contentSize = CGSizeZero
        for ref in self.textRefs(text) {
//            println("ref = [\(ref.value)]")
            if lines.first == nil {
                let line = WMLine()
                line.number = 0
                lines.append(line)
            }
            
            var lastLine = lines.last!
            lastLine.refs.append(ref)
            var wholeString = lastLine.textRefsStringRepresentation
            
            var newContentSize = self.sizeForText(wholeString)
            if contentSize == CGSizeZero {
                contentSize =  newContentSize
                continue
            }
            
            if newContentSize.width > self.viewSize.width {
//                println("new content = \(newContentSize.width), \(newContentSize.height)")
                contentSize = newContentSize
                var newLine = WMLine()
                newLine.number = lines.last!.number + 1
                
                /// move last ref from last line to the new line
                var refsToMoveNumber = 1
                let lastRef = lastLine.refs.last!
                if lastRef is WMWhitespaceRef {
                    refsToMoveNumber = 2
                }
                
                var moved = [WMTextRef]()
                for i in 0..<refsToMoveNumber {
                    moved.append(lastLine.refs.last!)
                    lastLine.refs.removeLast()
                }
                
                if lastLine.refs.last is WMWhitespaceRef {
                    lastLine.refs.removeLast()
                }
                
                for ref in moved.reverse() {
                    newLine.refs.append(ref)
                }
                
                lines.append(newLine)
                contentSize = CGSizeZero
            }
        }
        
        for line in lines {
            println("\(line.number):, \(line.textRefsStringRepresentation)")
        }
        
        return lines
    }
    
    func debug() {
        let debugView = WMView(size: self.viewSize, words: self.words, font: self.font)
        debugView.prepare()
        let debugImage = debugView.snapshot()
        println("debug snapshot")
    }
    
    func wordForPoint(point: CGPoint) -> WordProxy? {
        if self.words.count == 0 {
            return nil
        }
        
        if self.view == nil {
            self.view = WMView(size: self.viewSize, words: self.words, font: self.font)
            self.view!.prepare()
        }
        
        return self.view!.wordForPoint(point)
    }
}

public func == (lhs: NSRange, rhs: NSRange) -> Bool {
    return lhs.location == rhs.location && lhs.length == rhs.length
}

extension NSRange: Equatable {
    func containsRange(r: NSRange) -> Bool {
        let start = self.location
        let end = start + self.length
        return (r.location >= start) && ((r.location + r.length) <= end)
    }
}
