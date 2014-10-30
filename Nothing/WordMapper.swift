//
//  TappableLabelController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 28/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import UIKit

struct WMTappableText {
    let text: WMText
    let tappable: Bool
}
    
class WordMapper {
    private let font: UIFont
    private let viewSize: CGSize
    private var tappableTexts: [WMTappableText] = [WMTappableText]()
    private var view: WMInternaliew?
    
    init(font: UIFont, viewSize: CGSize) {
        self.font = font
        self.viewSize = viewSize
    }
    
    func mapWordsSeparatedByWhiteSpaceAndNewLineCharacterSet(text: String) {
        let analyzer = WMTextAnalyzer(text: text, font: self.font, size: self.viewSize)
        let lines = analyzer.analize()
        
        var objects = [WMTappableText]()
        for line in lines {
            for text in line.texts {
                objects.append(WMTappableText(text: text, tappable: text.isWord))
            }
        }
        
        self.tappableTexts = objects
        self.debug()
    }
    
    func mapWordsUsingRanges(ranges: [WMWordRange], text: String) {
        let analyzer = WMTextAnalyzer(text: text, font: self.font, size: self.viewSize)
        let lines = analyzer.analize()

        var objects = [WMTappableText]()
        for line in lines {
            for text in line.texts {
                var isTappable = false
                for range in ranges {
                    isTappable = text.ref.range == range
                    if (isTappable) {
                        break
                    }
                }
                
                objects.append(WMTappableText(text: text, tappable: isTappable))
            }
        }
        
        self.tappableTexts = objects
        self.debug()
    }
    
    func debug() {
        let debugView = WMInternaliew(size: self.viewSize, texts: self.tappableTexts, font: self.font)
        debugView.prepare()
        let debugImage = debugView.snapshot()
        println("debug snapshot")
    }
    
    func wordForPoint(point: CGPoint) -> WordProxy? {
        if self.tappableTexts.count == 0 {
            return nil
        }
        
        if self.view == nil {
            self.view = WMInternaliew(size: self.viewSize, texts: self.tappableTexts, font: self.font)
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
