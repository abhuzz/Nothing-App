//
//  NSNumber.swift
//  Nothing
//
//  Created by Tomasz Szulc on 23/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation

extension Bool {
    func toNSNumber() -> NSNumber {
        return NSNumber(bool: self)
    }
}