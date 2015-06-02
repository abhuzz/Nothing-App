//
//  NSSet_TS.swift
//  Nothing
//
//  Created by Tomasz Szulc on 03/03/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation

extension NSSet {
    func mutableSet() -> NSMutableSet {
        return NSMutableSet(set: self)
    }
}