//
//  Task.swift
//  CoreDataDemo
//
//  Created by Tomasz Szulc on 26/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import CoreLocation

@objc(Task)
class Task: NSManagedObject {
    
    @NSManaged var connections: NSSet
    @NSManaged var dateReminderInfo: DateReminderInfo?
    @NSManaged var locationReminderInfos: NSSet
    @NSManaged var longDescription: String?
    @NSManaged var uniqueIdentifier: String
    @NSManaged private var stateNumber: NSNumber
    @NSManaged var title: String!
    @NSManaged var trashed: NSNumber
    @NSManaged var useOpenHours: NSNumber
}

extension Task {
    
    enum State: Int {
        case Active = 0
        case Done
    }
    
    var state: State {
        get { return State(rawValue: self.stateNumber.integerValue)! }
        set { self.stateNumber = NSNumber(integer: newValue.rawValue) }
    }
    
    func changeState() {
        if self.state == .Active {
            self.state = .Done
        } else {
            self.state = .Active
        }
    }
}