//
//  NSManagedObjectContext_TS.swift
//  Nothing
//
//  Created by Tomasz Szulc on 28/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func saveContextDownTheHierarchy() {
        var c: NSManagedObjectContext? = self
        while (c != nil) {
            c!.performBlockAndWait({ () -> Void in
                c!.save(nil)
            })
            c = c!.parentContext
        }
    }
}