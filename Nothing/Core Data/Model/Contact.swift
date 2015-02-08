//
//  Contact.swift
//  CoreDataDemo
//
//  Created by Tomasz Szulc on 27/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

@objc(Contact)
class Contact: Connection {
    /// TODO: Change it to contact ID from address book
    @NSManaged var email: String?
    @NSManaged var name: String
    @NSManaged var phone: String?
}