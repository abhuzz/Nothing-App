//
//  Reminder.swift
//  Nothing
//
//  Created by Tomasz Szulc on 03/03/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import CoreData

@objc(Reminder)
class Reminder: NSManagedObject {

    @NSManaged var task: Task

}
