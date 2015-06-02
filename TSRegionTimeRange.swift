//
//  TSRegionTimeRange.swift
//  Nothing
//
//  Created by Tomasz Szulc on 01/03/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation

class TSRegionTimeRange {
    
    enum Weekday: Int {
        case Sunday = 1
        case Monday
        case Tuesday
        case Wednesday
        case Thursday
        case Friday
        case Saturday
    }
    
    var openHourTimeInterval: NSTimeInterval!
    var closeHourTimeInterval: NSTimeInterval!
    var day: TSRegionTimeRange.Weekday!
    
    init(day: TSRegionTimeRange.Weekday, openHourTimeInterval: NSTimeInterval, closeHourTimeInterval: NSTimeInterval) {
        self.day = day
        self.openHourTimeInterval = openHourTimeInterval
        self.closeHourTimeInterval = closeHourTimeInterval
    }
}