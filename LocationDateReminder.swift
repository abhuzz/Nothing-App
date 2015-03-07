//
//  LocationDateReminder.swift
//  Nothing
//
//  Created by Tomasz Szulc on 03/03/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import CoreData

@objc(LocationDateReminder)
class LocationDateReminder: Reminder {

    @NSManaged var fromDate: NSDate
    @NSManaged var toDate: NSDate
    @NSManaged var repeatIntervalNumber: NSNumber
    @NSManaged var distance: NSNumber
    @NSManaged var onArrive: NSNumber
    @NSManaged var place: Place

    var repeatInterval: NSCalendarUnit {
        set { self.repeatIntervalNumber = NSNumber(unsignedLong: newValue.rawValue) }
        get { return NSCalendarUnit(rawValue: self.repeatIntervalNumber.unsignedLongValue) }
    }
}
