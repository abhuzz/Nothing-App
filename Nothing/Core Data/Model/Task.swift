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
    @NSManaged private var dateReminderInfo: DateReminderInfo?
    @NSManaged private var locationReminderInfo: LocationReminderInfo?
    @NSManaged private var connections: NSSet
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
    
    var dateReminder: DateReminderInfo? {
        set { self.dateReminderInfo = newValue }
        get { return self.dateReminderInfo }
    }
    
    var locationReminder: LocationReminderInfo? {
        set {
            self.removeConnection(self.locationReminderInfo?.place)
            self.locationReminderInfo = newValue
            
            if self.locationReminderInfo != nil {
                self.addConnection(self.locationReminderInfo!.place)
            }
        }
        
        get {
            return self.locationReminderInfo
        }
    }
    
    func addConnection(connection: Connection) {
        var add = true
        for c in self.allConnections {
            if c as Connection == connection {
                add = false
                break
            }
        }
        
        if add {
            var connections = self.mutableSetValueForKey("connections")
            connections.addObject(connection)
        }
    }
    
    private func removeConnection(connection: Connection?) {
        if connection == nil {
            return
        }
        
        for c in self.allConnections {
            if c as Connection == connection! {
                var connections = self.mutableSetValueForKey("connections")
                connections.removeObject(c)
                return
            }
        }
    }
    
    var allConnections: NSSet {        
        return NSSet(set: self.connections)
    }
}