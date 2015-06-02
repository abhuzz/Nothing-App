//
//  NSMutableSet.swift
//  Nothing
//
//  Created by Tomasz Szulc on 03/03/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation

extension NSMutableSet {
    func immutableSet() -> NSSet {
        return NSSet(set: self)
    }
}