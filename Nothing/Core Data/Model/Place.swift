//
//  Place.swift
//  CoreDataDemo
//
//  Created by Tomasz Szulc on 27/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

@objc(Place)
class Place: Link {
    @NSManaged var name: String!
    @NSManaged private var latitude: NSNumber
    @NSManaged private var longitude: NSNumber
    @NSManaged var openHours: NSOrderedSet
    @NSManaged var useOpenHours: NSNumber
    @NSManaged var locationReminders: NSSet
}

extension Place {
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
    }
    
    var coordinate: CLLocationCoordinate2D {
        get { return CLLocationCoordinate2DMake( self.latitude.doubleValue, self.longitude.doubleValue) }
        set {
            self.latitude = NSNumber(double: newValue.latitude)
            self.longitude = NSNumber(double: newValue.longitude)
        }
    }
    
    func removeAllAssociatedObjects(context: NSManagedObjectContext!) {
        for info in self.locationReminders.allObjects as! [LocationReminder] {
            context.deleteObject(info)
        }
    }
    
    var associatedTasks: [Task] {
        var tasks = [Task]()
        
        for reminder in self.locationReminders.allObjects as! [LocationReminder] {
            tasks.append(reminder.task)
        }
        
        return tasks
    }
}
