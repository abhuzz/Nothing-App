//
//  TMTextSize.swift
//  Nothing
//
//  Created by Tomasz Szulc on 30/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import UIKit

class TMTextSize {
    class func size(text: NSString, font: UIFont, size: CGSize) -> CGSize {
        var label = UILabel(frame: CGRectZero)
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.bounds.size
    }
}