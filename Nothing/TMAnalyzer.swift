//
//  WMTextAnalyzer.swift
//  Nothing
//
//  Created by Tomasz Szulc on 29/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import UIKit

class TMText {
    let ref: TMTextRef
    let size: CGSize
    var line: Int
    
    init(ref: TMTextRef, size: CGSize, line: Int = 0) {
        self.ref = ref
        self.size = size
        self.line = line
    }
    
    /// is word or whitespace
    var isWord: Bool {
        return (self.ref is TMWordRef)
    }
}

class TMLine {
    var number = 0
    var range = NSMakeRange(0, 0)
    var texts = [TMText]()
    
    var textRefsStringRepresentation: String {
        var output = ""
        for text in self.texts {
            output += text.ref.value
        }
        
        return output
    }
}

class TMAnalyzer {
    /// text to be analized
    private var text: String
    
    /// font used to draw text
    private var font: UIFont
    
    /// size of view where text is drawed
    private var size: CGSize
    
    init(text: String, font: UIFont, size: CGSize) {
        self.text = text
        self.font = font
        self.size = size
    }
    
    func analize() -> [TMLine] {
        return self.mapLines(self.text, font: self.font, size: self.size)
    }
    
    private func mapLines(text: String, font: UIFont, size: CGSize) -> [TMLine] {
        
        var lines = [TMLine]()
        
        var contentSize = CGSizeZero
        for ref in WMTextRefDetector.textRefs(text) {
            /// create first line if not exist
            if lines.first == nil {
                let line = TMLine()
                line.number = 0
                lines.append(line)
            }
            
            /// get last line
            let lastLine = lines.last!
            
            /// create object with text ref
            let wmText = TMText(ref: ref, size: self.sizeForText(ref.value, font: self.font, size: self.size), line: lastLine.number)
            
            /// add it to the line
            lastLine.texts.append(wmText)
            
            /// calculate size of the line in with current words
            var entireString = lastLine.textRefsStringRepresentation
            var newContentSize = self.sizeForText(entireString, font: font, size: size)
            
            /// if content size is not set, set it and jump to next step
            if contentSize == CGSizeZero {
                contentSize =  newContentSize
                continue
            }
            
            
            /**  If width of the line is greater than width of the view where text 
            is presented create new line. Check if last WMText in the line is whitespace 
            or not. If yes, move 2 items from last line to the new one, otherwise move one.
            *UILabel behaves similar.*
            */
            if newContentSize.width > self.size.width {
                contentSize = newContentSize
                
                /// create new line
                var newLine = TMLine()
                newLine.number = lines.last!.number + 1
                
                /// get number of objects to move to the new line
                var numberOfObjectsToMove = 1
                let lastText = lastLine.texts.last!
                if !lastText.isWord {
                    numberOfObjectsToMove = 2
                }
                
                /// remove objects from last line and store it in array
                var objectsToMove = [TMText]()
                for i in 0..<numberOfObjectsToMove {
                    objectsToMove.append(lastLine.texts.last!)
                    lastLine.texts.removeLast()
                }
                
                /// after objects are removed, if there is whitespace on last position, remove it (*like UILabel does it, I guess*)
                if !lastLine.texts.last!.isWord {
                    lastLine.texts.removeLast()
                }
                
                /// reverse objects
                for object in objectsToMove.reverse() as [TMText] {
                    object.line = newLine.number
                    newLine.texts.append(object)
                }
                
                /// add line and reset content size of current line
                lines.append(newLine)
                contentSize = CGSizeZero
            }
        }
        
        self.debug(lines)
        return lines
    }
    
    private func sizeForText(text: NSString, font: UIFont, size: CGSize) -> CGSize {
        var label = UILabel(frame: CGRectZero)
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.bounds.size
    }
    
    private func debug(lines: [TMLine]) {
        for line in lines {
            println("\(line.number):, \(line.textRefsStringRepresentation)")
        }
    }
}