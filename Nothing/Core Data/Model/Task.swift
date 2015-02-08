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

@objc(Task)
class Task: NSManagedObject {
    
    @NSManaged var title: String
    @NSManaged var longDescription: String?
    @NSManaged private var stateNumber: NSNumber
    @NSManaged var dateReminderInfo: DateReminderInfo?
    @NSManaged var locationReminderInfo: LocationReminderInfo?
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
    
    func removeConnection(connection: Connection?) {
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
    
    func changeState() {
        if self.state == .Active {
            self.state = .Done
        } else {
            self.state = .Active
        }
    }
    
    func schedule() {
        if let reminder = self.dateReminderInfo {
            let taskObjectID = self.objectID.URIRepresentation().absoluteString!
            
            /// Find existing local notification and cancel it
            for notification in UIApplication.sharedApplication().scheduledLocalNotifications as [UILocalNotification] {
                if let info = notification.userInfo as [NSObject: AnyObject]? {
                    if let objectID = info["objectID"] as? String {
                        if objectID == taskObjectID {
                            UIApplication.sharedApplication().cancelLocalNotification(notification)
                            break
                        }
                    }
                }
            }
            
            /// Schedlue new local notification
            let notification = UILocalNotification()
            notification.fireDate = reminder.fireDate
            notification.repeatInterval = reminder.repeatInterval
            notification.alertBody = self.title
            notification.userInfo = ["objectID": taskObjectID]
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }
}