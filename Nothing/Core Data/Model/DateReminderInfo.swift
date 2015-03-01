//
//  DateReminderInfo.swift
//  CoreDataDemo
//
//  Created by Tomasz Szulc on 26/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import CoreData

@objc(DateReminderInfo)
class DateReminderInfo: NSManagedObject {
    @NSManaged var fireDate: NSDate!
    @NSManaged private var repeatIntervalNumber: NSNumber
    @NSManaged private var task: Task?
}

extension DateReminderInfo {
    
    var repeatInterval: NSCalendarUnit {
        get { return NSCalendarUnit(self.repeatIntervalNumber.unsignedLongValue) }
        set { self.repeatIntervalNumber = NSNumber(unsignedLong: newValue.rawValue) }
    }
}