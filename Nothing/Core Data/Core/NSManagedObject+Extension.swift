//
//  NSManagedObject_Extension.swift
//  CoreDataDemo
//
//  Created by Tomasz Szulc on 26/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

extension NSManagedObject {
    class func create<T: NSManagedObject>(context: NSManagedObjectContext) -> T {
        return NSEntityDescription.insertNewObjectForEntityForName(NSStringFromClass(T.self), inManagedObjectContext: context) as! T
    }
    
    class func createNotInserted<T: NSManagedObject>(context: NSManagedObjectContext) -> T {
        var entity = NSEntityDescription.entityForName(NSStringFromClass(T.self), inManagedObjectContext: context)
        let object: T = T(entity: entity!, insertIntoManagedObjectContext: nil)
        return object
    }
}
