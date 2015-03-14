//
//  ModelController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 02/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import CoreData

class ModelController {
    func allTasks() -> [Task] {
        let request = NSFetchRequest(entityName: NSStringFromClass(Task.self))
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
        return (CDHelper.mainContext.executeFetchRequest(request, error: nil) as! [Task]) ?? [Task]()
    }
    
    func allTasksNotDoneAndNotTrashed() -> [Task] {
        let request = NSFetchRequest(entityName: NSStringFromClass(Task.self))
        request.predicate = NSPredicate(format: "trashed == 0 && stateNumber == 0", argumentArray: nil)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
        return (CDHelper.mainContext.executeFetchRequest(request, error: nil) as! [Task]) ?? [Task]()
    }
    
    func activeTasksForPlace(place: Place) -> [Task] {
        let tasks = self.allTasksNotDoneAndNotTrashed()
        var result = [Task]()
        
        for task in tasks {
            var found = false
            for reminder in task.locationReminders {
                if (reminder.place == place) {
                    found = true
                    break
                }
            }
            
            if found {
                result.append(task)
            }
        }
        
        return result
    }
    
    func findTask(identifier: String) -> Task? {
        let request = NSFetchRequest(entityName: NSStringFromClass(Task.self))
        request.predicate = NSPredicate(format: "uniqueIdentifier = %@", identifier)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
        return CDHelper.mainContext.executeFetchRequest(request, error: nil)?.first as? Task
    }
    
    func allPlaces(context: NSManagedObjectContext) -> [Place] {
        let request = NSFetchRequest(entityName: NSStringFromClass(Place.self))
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        return (context.executeFetchRequest(request, error: nil) as! [Place]) ?? [Place]()
    }
    
    func allContacts(context: NSManagedObjectContext) -> [Contact] {
        let request = NSFetchRequest(entityName: NSStringFromClass(Contact.self))
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        return (context.executeFetchRequest(request, error: nil) as! [Contact]) ?? [Contact]()
    }
}
