//
//  TappableLabelController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 28/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import UIKit

typealias TMTextRange = NSRange

class TMTextProxy {
    let value: String
    
    init(_ text: TMText) {
        self.value = text.ref.value
    }
}
    
class TMMapper {
    /// font of text
    private let font: UIFont
    
    /// size of view where text is presented
    private let viewSize: CGSize
    
    /**
    Internal view where analyzed text is drawed,
    Coordinates of taps are used to detect which text is tapped
    */
    private var view: WMInternaliew?
    
    /// lines of analyzed text. Lines contain words
    private var lines: [TMLine] = [TMLine]()
    
    private var texts: [TMText] {
        var objects = [TMText]()
        for line in lines {
            for text in line.texts {
                objects.append(text)
            }
        }
        
        return objects
    }
    
    init(font: UIFont, viewSize: CGSize) {
        self.font = font
        self.viewSize = viewSize
    }
    
    func mapTextAndMakeAllTappable(text: String) {
        self.map(text)
    }
    
    func mapTextWithTappableRanges(ranges: [TMTextRange], text: String) {
        self.map(text)
    }
    
    private func map(text: String) {
        let analyzer = TMAnalyzer(text: text, font: self.font, size: self.viewSize)
        self.lines = analyzer.analize()
        self.debug()
    }
    
    private func debug() {
        let debugView = WMInternaliew(size: self.viewSize, texts: self.texts, font: self.font)
        debugView.prepare()
        let debugImage = debugView.snapshot()
        println("debug")
    }
    
    func textForPoint(point: CGPoint) -> TMTextProxy? {
        if self.texts.count == 0 {
            return nil
        }
        
        if self.view == nil {
            self.view = WMInternaliew(size: self.viewSize, texts: self.texts, font: self.font)
            self.view!.prepare()
        }
        
        if let text = self.view!.textForPoint(point) {
            return TMTextProxy(text)
        }
        
        return nil
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
