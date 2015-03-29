//
//  CoreDataStore.swift
//
//  Created by Tomasz Szulc on 22/09/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import CoreData

class CDStore {
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        
        var model = NSManagedObjectModel(contentsOfURL: NSBundle.mainBundle().URLForResource("Nothing", withExtension: "momd")!)!
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: model)

        let documentsDirectory = (NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask) as! [NSURL]).last!
        let storeURL = documentsDirectory.URLByAppendingPathComponent("Nothing.sqlite")
        
        let storeOptions = [
            NSPersistentStoreUbiquitousContentNameKey: "Store2"
        ]
        
        var error: NSError? = nil
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: storeOptions, error: &error) == nil {
            
            /// Failed to initialize Core Data
            abort()
        }
        
        return coordinator
    }()
}