//
//  LocationReminderInfo.swift
//  CoreDataDemo
//
//  Created by Tomasz Szulc on 27/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit
import CoreData

@objc(LocationReminderInfo)
class LocationReminderInfo: NSManagedObject {
    @NSManaged private var distanceNumber: NSNumber
    @NSManaged private var onArriveBool: NSNumber
    @NSManaged var place: Place?
    @NSManaged var task: Task?
}

extension LocationReminderInfo {
    var onArrive: Bool {
        get { return self.onArriveBool.boolValue }
        set { self.onArriveBool = NSNumber(bool: newValue) }
    }
    
    var distance: Float {
        get { return self.distanceNumber.floatValue }
        set { self.distanceNumber = NSNumber(float: newValue) }
    }
}
