//
//  Task.swift
//  CoreDataDemo
//
//  Created by Tomasz Szulc on 26/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import CoreData

@objc(Task)
class Task: NSManagedObject {
    
    @NSManaged var title: String
    @NSManaged var longDescription: String?
    @NSManaged private var stateNumber: NSNumber
    @NSManaged var dateReminderInfo: DateReminderInfo?
    @NSManaged var locationReminderInfo: LocationReminderInfo?
    @NSManaged var connections: NSMutableSet
}

extension Task {
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        self.connections = NSMutableSet()
    }
    
    enum State: Int {
        case Active = 0
        case Done
    }
    
    var state: State {
        get { return State(rawValue: self.stateNumber.integerValue)! }
        set { self.stateNumber = NSNumber(integer: newValue.rawValue) }
    }
}