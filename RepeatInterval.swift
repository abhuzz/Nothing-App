//
//  RepeatInterval.swift
//  Nothing
//
//  Created by Tomasz Szulc on 07/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation

class RepeatInterval {
    class func allIntervals() -> Array<NSCalendarUnit> {
        return [
            NSCalendarUnit.allZeros,
            NSCalendarUnit.CalendarUnitDay,
            NSCalendarUnit.CalendarUnitWeekOfYear,
            NSCalendarUnit.CalendarUnitMonth,
            NSCalendarUnit.CalendarUnitYear
        ]
    }
    
    class func descriptionForInterval(interval i : NSCalendarUnit) -> String {
        if i == NSCalendarUnit.allZeros { return String.noneRepeatInterval() }
        if i == NSCalendarUnit.CalendarUnitDay { return String.onceADayRepeatInterval() }
        if i == NSCalendarUnit.CalendarUnitWeekOfYear { return String.onceAWeakRepeatInterval() }
        if i == NSCalendarUnit.CalendarUnitMonth { return String.onceAMonthRepeatInterval() }
        if i == NSCalendarUnit.CalendarUnitYear { return String.onceAYearRepeatInterval() }
        return ""
    }
}