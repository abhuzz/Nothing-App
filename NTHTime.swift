//
//  NTHTime.swift
//  Nothing
//
//  Created by Tomasz Szulc on 28/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation

struct NTHTime {
    let timeInterval: NSTimeInterval
    
    let hours: Int
    let minutes: Int
    
    init(interval: NSTimeInterval) {
        self.timeInterval = interval
        
        self.hours = Int(interval / 3600)
        self.minutes = Int(Int(interval/60) - (self.hours * 60))
    }
    
    func toString() -> String {
        return String(format: "%02d:%02d", self.hours, self.minutes)
    }
}