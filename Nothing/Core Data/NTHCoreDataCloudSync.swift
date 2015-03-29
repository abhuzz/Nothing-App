//
//  NTHCoreDataCloudSync.swift
//  Nothing
//
//  Created by Tomasz Szulc on 29/03/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import CoreData

protocol NTHCoreDataCloudSyncProtocol: NSObjectProtocol {
//    func persistentStoreWillChange()
//    func persistentStoreDidChange()
    func persistentStoreDidReceiveChanges()
}

let NTHCoreDataCloudSyncStoreWillChangeNotification = "NTHCoreDataCloudSyncStoreWillChangeNotification"
let NTHCoreDataCloudSyncStoreDidChangeNotification = "NTHCoreDataCloudSyncStoreDidChangeNotification"
let NTHCoreDataCloudSyncDidImportContentChangesNotification = "NTHCoreDataCloudSyncDidImportContentChangesNotification"

class NTHCoreDataCloudSync: NSObject {
    class var sharedInstance: NTHCoreDataCloudSync! {
        struct Static { static var instance = NTHCoreDataCloudSync() }
        return Static.instance
    }
    
    override init() {
        super.init()
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "_persistentStoreWillChange:", name: NSPersistentStoreCoordinatorStoresWillChangeNotification, object:nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "_persistentStoreDidChange:", name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "_didReceiveICloudChanges:", name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: CDHelper.mainContext.persistentStoreCoordinator)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /// Observers
    func addObserver(observer: NTHCoreDataCloudSyncProtocol) {
//        NSNotificationCenter.defaultCenter().addObserver(observer, selector: "persistentStoreWillChange", name: NTHCoreDataCloudSyncStoreWillChangeNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(observer, selector: "persistentStoreDidChange", name: NTHCoreDataCloudSyncStoreDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: "persistentStoreDidReceiveChanges", name: NTHCoreDataCloudSyncDidImportContentChangesNotification, object: nil)
    }
    
    func removeObserver(observer: NTHCoreDataCloudSyncProtocol) {
//        NSNotificationCenter.defaultCenter().removeObserver(observer, name: NTHCoreDataCloudSyncStoreWillChangeNotification, object: nil)
//        NSNotificationCenter.defaultCenter().removeObserver(observer, name: NTHCoreDataCloudSyncStoreDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(observer, name: NTHCoreDataCloudSyncDidImportContentChangesNotification, object: nil)
    }
    
    /// Notifications
    /*
    func _persistentStoreWillChange(notification: NSNotification) {
        println("_persistentStoreWillChange:")
        CDHelper.mainContext.performBlock { () -> Void in
            if CDHelper.mainContext.hasChanges {
                var error: NSError?
                CDHelper.mainContext.save(&error)
                if let err = error {
                    println("save error: \(err)")
                } else {
                    CDHelper.mainContext.reset()
                }
                
                NSNotificationCenter.defaultCenter().postNotificationName(NTHCoreDataCloudSyncStoreWillChangeNotification, object: nil)
            }
        }
    }
    
    func _persistentStoreDidChange(notification: NSNotification) {
        println("_persistentStoreDidChange:")
        NSNotificationCenter.defaultCenter().postNotificationName(NTHCoreDataCloudSyncStoreDidChangeNotification, object: nil)
    }
    */
    func _didReceiveICloudChanges(notification: NSNotification) {
        println("_didReceiveICloudChanges:")
        CDHelper.mainContext.performBlock { () -> Void in
            CDHelper.mainContext.mergeChangesFromContextDidSaveNotification(notification)
            NSNotificationCenter.defaultCenter().postNotificationName(NTHCoreDataCloudSyncDidImportContentChangesNotification, object: nil)
        }
    }
}
