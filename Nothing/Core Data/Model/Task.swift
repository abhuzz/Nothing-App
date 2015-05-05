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
    
    @NSManaged var createdAt: NSDate
    @NSManaged var links: NSSet
    @NSManaged var longDescription: String?
    @NSManaged var uniqueIdentifier: String
    @NSManaged private var stateNumber: NSNumber
    @NSManaged var title: String!
    @NSManaged var trashed: NSNumber
    @NSManaged var reminders: NSSet
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
    

    /// Reminders
    func addReminder(reminder: Reminder) {
        let mutableSet = self.reminders.mutableSet()
        mutableSet.addObject(reminder)
        self.reminders = mutableSet.immutableSet()
    }
    
    func removeReminder(reminder: Reminder) {
        let mutableSet = self.reminders.mutableSet()
        mutableSet.removeObject(reminder)
        self.reminders = mutableSet.immutableSet()
    }
    
    var dateReminders: [DateReminder] {
        return filter(self.reminders.allObjects) { $0 is DateReminder } as! [DateReminder]
    }
    
    var locationReminders: [LocationReminder] {
        return filter(self.reminders.allObjects) { $0 is LocationReminder } as! [LocationReminder]
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
    
    var placeLinks: [Place] {
        get {
            return filter(self.links.allObjects) { $0 is Place } as! [Place]
        }
        
        set {
            var updatedLinks = [Link]()
            
            for place in newValue {
                updatedLinks.append(place)
            }
            
            let links = self.links.allObjects as! [Link]
            for link in links {
                if !(link is Place) {
                    updatedLinks.append(link)
                }
            }
            
            self.links = NSSet(array: updatedLinks)
        }
    }
    
    var contactLinks: [Contact] {
        get {
            return filter(self.links.allObjects) { $0 is Contact } as! [Contact]
        }
        
        set {
            var updatedLinks = [Link]()
            
            for contact in newValue {
                updatedLinks.append(contact)
            }
            
            let links = self.links.allObjects as! [Link]
            for link in links {
                if !(link is Contact) {
                    updatedLinks.append(link)
                }
            }
            
            self.links = NSSet(array: updatedLinks)
        }
    }
    
    /// Schedule
    func schedule() {
        LocalNotificationScheduler.cancelScheduledNotifications(self)
        LocalNotificationScheduler.scheduleNotification(self)
    }
    
    
    func snooze(seconds: NSTimeInterval) {
        
        for reminder in self.dateReminders {
            reminder.fireDate = reminder.fireDate.dateByAddingTimeInterval(seconds)
        }
        
        self.managedObjectContext?.save(nil)
        self.schedule()
    }
}
