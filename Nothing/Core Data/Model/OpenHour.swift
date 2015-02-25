//
//  OpenHours.swift
//  Nothing
//
//  Created by Tomasz Szulc on 23/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import CoreData

class OpenHour: NSManagedObject {

    @NSManaged var closeHour: NSDate
    @NSManaged var day: NSNumber
    @NSManaged var openHour: NSDate
    @NSManaged var place: Place
    @NSManaged var enabled: Bool
    @NSManaged var closed: Bool
}
