//
//  OpenHours.swift
//  Nothing
//
//  Created by Tomasz Szulc on 23/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import CoreData

@objc(OpenTimeRange)
class OpenTimeRange: NSManagedObject {
    
    enum Day: Int {
        case Monday = 1
        case Tuesday = 2
        case Wednesday = 3
        case Thursday = 4
        case Friday = 5
        case Saturday = 6
        case Sunday = 7
    }

    @NSManaged private var openTimeIntervalNumber: NSNumber
    @NSManaged private var closeTimeIntervalNumber: NSNumber
    @NSManaged var dayNumber: NSNumber
    @NSManaged var place: Place
    @NSManaged var closed: Bool
    
    var openTimeInterval: NSTimeInterval! {
        set { self.openTimeIntervalNumber = NSNumber(integer: Int(newValue)) }
        get { return NSTimeInterval(self.openTimeIntervalNumber.integerValue) }
    }
    
    var closeTimeInterval: NSTimeInterval! {
        set { self.closeTimeIntervalNumber = NSNumber(integer: Int(newValue)) }
        get { return NSTimeInterval(self.closeTimeIntervalNumber.integerValue) }
    }
    
    var day: Day {
        return Day(rawValue: self.dayNumber.integerValue)!
    }
    
    var dayString: String {
        switch self.day {
        case .Monday: return "Monday"
        case .Tuesday: return "Tuesday"
        case .Wednesday: return "Wednesday"
        case .Thursday: return "Thursday"
        case .Friday: return "Friday"
        case .Saturday: return "Saturday"
        case .Sunday: return "Sunday"
        }
    }
}
