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
