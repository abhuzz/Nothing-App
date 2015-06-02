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
        case Sunday = 1
        case Monday
        case Tuesday
        case Wednesday
        case Thursday
        case Friday
        case Saturday
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
        case .Sunday: return "Sunday"
        case .Monday: return "Monday"
        case .Tuesday: return "Tuesday"
        case .Wednesday: return "Wednesday"
        case .Thursday: return "Thursday"
        case .Friday: return "Friday"
        case .Saturday: return "Saturday"
        }
    }
}
