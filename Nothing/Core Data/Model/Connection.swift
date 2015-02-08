//
//  Connection.swift
//  CoreDataDemo
//
//  Created by Tomasz Szulc on 27/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit
import CoreData

@objc(Connection)
class Connection: NSManagedObject {
    @NSManaged var tasks: NSSet
}

extension Connection {
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        self.tasks = NSSet()
    }
}