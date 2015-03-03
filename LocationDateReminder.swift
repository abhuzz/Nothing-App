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

    @NSManaged var sinceDate: NSDate
    @NSManaged var toDate: NSDate
    @NSManaged var repeatInterval: NSNumber
    @NSManaged var distance: NSNumber
    @NSManaged var onArrive: NSNumber
    @NSManaged var place: Place

}
