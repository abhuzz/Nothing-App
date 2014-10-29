//
//  WMTypes.swift
//  Nothing
//
//  Created by Tomasz Szulc on 29/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import UIKit

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

class WMLine {
    var number = 0
    var range = NSMakeRange(0, 0)
    var refs = [WMTextRef]()

    var textRefsStringRepresentation: String {
        var output = ""
        for ref in self.refs {
            output += ref.value
        }
        
        return output
    }
}

/// internal struct
struct WMWord {
    var text: String
    var size: CGSize
    var line: Int
    var tappable: Bool = false
}

typealias WMWordRange = NSRange



/// proxy of `WMWord` which contain returned text
typealias WordProxy = WMWordProxy
class WMWordProxy {
    let text: String
    
    init(_ word: WMWord) {
        self.text = word.text
    }
}
