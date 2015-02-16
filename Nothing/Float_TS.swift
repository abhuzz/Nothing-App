//
//  CGFloat_TS.swift
//  Nothing
//
//  Created by Tomasz Szulc on 16/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation

extension Float {
    func metersOrKilometers() -> String {
        if (self < 1000) {
            return NSString(format: "%.0f m", self) as! String
        } else {
            return NSString(format: "%.1f km", self / 1000.0) as! String
        }
    }
}