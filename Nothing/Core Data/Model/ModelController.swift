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
    
}

extension ModelController {
    func allTasks() -> [Task] {
        let request = NSFetchRequest(entityName: NSStringFromClass(Task.self))
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
        return CDHelper.mainContext.executeFetchRequest(request, error: nil) as [Task]! ?? [Task]()
    }
    
    func tasksMatching(text: String) -> [Task] {
        let request = NSFetchRequest(entityName: NSStringFromClass(Task.self))
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
        
        let titlePredicate = NSPredicate(format: "self.title CONTAINS[cd] %@", text)!
        let descriptionPredicate = NSPredicate(format: "self.longDescription CONTAINS[cd] %@", text)!
        
        let orPredicate = NSCompoundPredicate.orPredicateWithSubpredicates([titlePredicate, descriptionPredicate])
        request.predicate = orPredicate
        
        return CDHelper.mainContext.executeFetchRequest(request, error: nil) as [Task]! ?? [Task]()
    }
}