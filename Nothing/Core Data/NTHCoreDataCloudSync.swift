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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "_didReceiveICloudChanges:", name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: CDHelper.mainContext.persistentStoreCoordinator)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /// Observers
    func addObserver(observer: NTHCoreDataCloudSyncProtocol) {
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: "persistentStoreDidReceiveChanges", name: NTHCoreDataCloudSyncDidImportContentChangesNotification, object: nil)
    }
    
    func removeObserver(observer: NTHCoreDataCloudSyncProtocol) {
        NSNotificationCenter.defaultCenter().removeObserver(observer, name: NTHCoreDataCloudSyncDidImportContentChangesNotification, object: nil)
    }
    

    func _didReceiveICloudChanges(notification: NSNotification) {
        println("_didReceiveICloudChanges:")
        println("*** iCloud Sync ***")
        CDHelper.mainContext.performBlock { () -> Void in
            CDHelper.mainContext.mergeChangesFromContextDidSaveNotification(notification)
            NSNotificationCenter.defaultCenter().postNotificationName(NTHCoreDataCloudSyncDidImportContentChangesNotification, object: nil)
        }
    }
}
