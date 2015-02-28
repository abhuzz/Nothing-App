//
//  CoreDataHelper.swift
//
//  Created by Tomasz Szulc Prywatny on 22/09/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import CoreData

class CDHelper: NSObject {
    
    /// Return main context. Created once.
    class var mainContext: NSManagedObjectContext {
        return CDHelper.sharedInstance.mainContext
    }
    
    /// Return temporary context with `mainContext` as the parent. Everytime new is returned.
    class var temporaryContext: NSManagedObjectContext {
        return CDHelper.sharedInstance.createTemporaryContext()
    }
    
    // Mark: Private section
    private let store: CDStore = CDStore()
    private class var sharedInstance: CDHelper! {
        struct Static {
            static var instance = CDHelper()
        }
        
        return Static.instance
    }
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("contextDidSaveContext:"), name: NSManagedObjectContextDidSaveNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func contextDidSaveContext(notification: NSNotification) {
        /// for future use with background context
        println("contextDidSaveContext:")
    }
    
    private lazy var mainContext: NSManagedObjectContext! = {
        let coordinator = self.store.persistentStoreCoordinator
        let type = NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType
        var context = NSManagedObjectContext(concurrencyType: type)
        context.persistentStoreCoordinator = coordinator
        return context
    }()
    
    class func temporaryContextWithParent(parent: NSManagedObjectContext!) -> NSManagedObjectContext {
        var context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        context.parentContext = parent
        return context
    }
    
    private func createTemporaryContext() -> NSManagedObjectContext {
        var context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        context.parentContext = self.mainContext
        return context
    }
    
    private func saveContext(context: NSManagedObjectContext) {
        var error: NSError? = nil
        if context.hasChanges && !context.save(&error) {
            println("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
    }
}