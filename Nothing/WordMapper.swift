//
//  TappableLabelController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 28/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import UIKit
    
/// internal struct
struct WMWord {
    var text: String
    var size: CGSize
    var line: Int
}

/// proxy of `WMWord` which contain returned text
typealias WordProxy = WMWordProxy
class WMWordProxy {
    let text: String
    
    init(_ word: WMWord) {
        self.text = word.text
    }
}

class WordMapper {
    private let font: UIFont
    private let viewSize: CGSize
    private var words: [WMWord] = [WMWord]()
    private var view: WMView?
    
    init(font: UIFont, viewSize: CGSize) {
        self.font = font
        self.viewSize = viewSize
    }
    
    func mapWordsSeparatedByWhiteSpaceAndNewLineCharacterSet(text: String) {
        func sizeForText(text: NSString) -> CGSize {
            return text.boundingRectWithSize(self.viewSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.font], context: nil).size
        }
        
        let whitespace = " "
        
        /// create array of words
        var rawWords = (text as NSString!).componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as [NSString]
        
        /// calculate size of words using font and view size and store them
        var currentString = ""
        var currentStringSize = CGSizeZero
        var currentLine = -1
        
        var wmWords = [WMWord]()
        for rawWord in rawWords {
            /// calculate size of whole text
            currentString += rawWord
            var whiteSpaceAdded = false
            if (rawWord != rawWords.last) {
                currentString += whitespace
                whiteSpaceAdded = true
            }
            
            /// save old size, get new and check if it matching to the same line or the new one
            let oldSize = currentStringSize
            currentStringSize = sizeForText(currentString)
            if currentStringSize.height > oldSize.height {
                currentLine++
            }
            
            /// create word
            let wmWord = WMWord(text: rawWord, size: sizeForText(rawWord), line: currentLine)
            wmWords.append(wmWord)
            if (whiteSpaceAdded) {
                /// create whitespace word
                let wmcWord = WMWord(text: whitespace, size: sizeForText(whitespace), line: currentLine)
                wmWords.append(wmcWord)
            }
        }
        
        /// assign mapped words
        self.words = wmWords
        
//        /// debug view
//        let debugView = WMView(size: self.viewSize, words: self.words, font: self.font)
//        debugView.prepare()
//        let debugImage = debugView.snapshot()
//        println("debug snapshot")
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
