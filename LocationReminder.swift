//
//  LocationReminder.swift
//  Nothing
//
//  Created by Tomasz Szulc on 03/03/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import CoreData

@objc(LocationReminder)
class LocationReminder: Reminder {

    @NSManaged var distance: NSNumber
    @NSManaged var onArrive: NSNumber
    @NSManaged var place: Place

}
