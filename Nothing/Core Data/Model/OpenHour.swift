//
//  OpenHours.swift
//  Nothing
//
//  Created by Tomasz Szulc on 23/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import CoreData

@objc(OpenHour)
class OpenHour: NSManagedObject {
    
    enum Day: Int {
        case Monday = 1
        case Tuesday = 2
        case Wednesday = 3
        case Thursday = 4
        case Friday = 5
        case Saturday = 6
        case Sunday = 7
    }

    @NSManaged private var openHourTimeInterval: NSNumber
    @NSManaged var dayNumber: NSNumber
    @NSManaged private var closeHourTimeInterval: NSNumber
    @NSManaged var place: Place
    @NSManaged var closed: Bool
    
    var openTimeInterval: NSTimeInterval! {
        set { self.openHourTimeInterval = NSNumber(integer: Int(newValue)) }
        get { return NSTimeInterval(self.openHourTimeInterval.integerValue) }
    }
    
    var closeTimeInterval: NSTimeInterval! {
        set { self.closeHourTimeInterval = NSNumber(integer: Int(newValue)) }
        get { return NSTimeInterval(self.closeHourTimeInterval.integerValue) }
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
