//
//  TappableLabelController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 28/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import UIKit

class WMController {
    let font: UIFont
    let viewSize: CGSize
    private var words: [WMWord] = [WMWord]()
    private var view: WMView?
    
    init(font: UIFont, viewSize: CGSize) {
        self.font = font
        self.viewSize = viewSize
    }
    
    func map(text: String) {
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
        
        var wmcWords = [WMWord]()
        for rawWord in rawWords {
            /// calculate size of whole text
            currentString += rawWord
            var whiteSpaceAdded = false
            if (rawWord != rawWords.last) {
                currentString += whitespace
                whiteSpaceAdded = true
            }
            
            let oldSize = currentStringSize
            currentStringSize = sizeForText(currentString)
            if currentStringSize.height > oldSize.height {
                currentLine++
            }
            
            let wmcWord = WMWord(text: rawWord, size: sizeForText(rawWord), line: currentLine)
            wmcWords.append(wmcWord)
            if (whiteSpaceAdded) {
                let wmcWord = WMWord(text: whitespace, size: sizeForText(whitespace), line: currentLine)
                wmcWords.append(wmcWord)
            }
        }
        
        /// assign mapped words
        self.words = wmcWords
        
        /*
        /// debug view
        let debugView = WMView(size: self.viewSize, words: self.words, font: self.font)
        debugView.prepare()
        let debugImage = debugView.snapshot()
        println("debug snapshot")
        */
    }
    
    func wordForPoint(point: CGPoint) -> WMWord? {
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