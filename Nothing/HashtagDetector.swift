//
//  HashtagFinder.swift
//  Nothing
//
//  Created by Tomasz Szulc on 28/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation

class HashtagDetector {
    
    typealias Result = (text: String, range: NSRange)
    private let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    func detect() -> [Result] {
        let matches = self.regexp.matchesInString(self.text, options: .ReportCompletion, range: NSMakeRange(0, countElements(self.text))) as [NSTextCheckingResult]
        
        var results = [Result]()
        for match in matches {
            let startIndex = advance(self.text.startIndex, match.range.location)
            let endIndex = advance(startIndex, match.range.length)
            let range = Range(start: startIndex, end: endIndex)
            let matchText = self.text[range]
            
            results.append(Result(text: matchText, range: match.range))
        }
        
        return results
    }
    
    private lazy var pattern: String = {
        return "[#][\\w]+"
    }()
    
    private lazy var regexp: NSRegularExpression = {
        return NSRegularExpression(pattern: self.pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)!
    }()
}