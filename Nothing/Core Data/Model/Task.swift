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
    
    @NSManaged var links: NSSet
    @NSManaged var dateReminderInfo: DateReminderInfo?
    @NSManaged var locationReminderInfos: NSSet
    @NSManaged var longDescription: String?
    @NSManaged var uniqueIdentifier: String
    @NSManaged private var stateNumber: NSNumber
    @NSManaged var title: String!
    @NSManaged var trashed: NSNumber
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
    
    /// Location Reminder
    func addLocationReminder(reminder: LocationReminderInfo) {
        let mutableSet = NSMutableSet(set: self.locationReminderInfos)
        mutableSet.addObject(reminder)
        self.locationReminderInfos = NSSet(set: mutableSet)
    }
    
    func removeLocationReminder(reminder: LocationReminderInfo) {
        let mutableSet = NSMutableSet(set: self.locationReminderInfos)
        mutableSet.removeObject(reminder)
        self.locationReminderInfos = NSSet(set: mutableSet)
    }
    
    /// Link
    func addLink(link: Link) {
        let mutableSet = NSMutableSet(set: self.links)
        mutableSet.addObject(link)
        self.links = NSSet(set: mutableSet)
    }
    
    func removeLink(link: Link) {
        let mutableSet = NSMutableSet(set: self.links)
        mutableSet.removeObject(link)
        self.links = NSSet(set: mutableSet)
    }
}