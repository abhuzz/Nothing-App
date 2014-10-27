//
//  CoreDataStore.swift
//
//  Created by Tomasz Szulc on 22/09/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import CoreData

class CDStore {
    private let storeName = "Nothing"
    
    lazy var applicationDocumentsDirectory: NSURL = {
        return (NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask) as [NSURL]).last!
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        return NSManagedObjectModel(contentsOfURL: NSBundle.mainBundle().URLForResource(self.storeName, withExtension: "momd")!)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("\(self.storeName)sqlite")
        var error: NSError? = nil
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's data"
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain:"Domain", code: 9999, userInfo: dict)
            println("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()
}