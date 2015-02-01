//
//  NTHAddressBookViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 01/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import AddressBook

class SimpleAB {
    
    class Record {
        private var record: ABRecordRef
        
        init(record: ABRecordRef) { self.record = record }
        
        var name: String {
            return ABRecordCopyCompositeName(self.record).takeRetainedValue() as String
        }
    }
    
    class func createAddressBook() -> ABAddressBookRef? {
        var errorRef: Unmanaged<CFErrorRef>? = nil
        let abRef: Unmanaged<ABAddressBookRef>! = ABAddressBookCreateWithOptions(nil, &errorRef)
        if let ab = abRef {
            return Unmanaged<NSObject>.fromOpaque(ab.toOpaque()).takeUnretainedValue()
        }
        return nil
    }
    
    class func checkAuthorizationStatus(completion: (status: ABAuthorizationStatus, success: Bool, error: CFErrorRef?) -> Void) {
        
        let authorizationStatus = ABAddressBookGetAuthorizationStatus()
        if (authorizationStatus == ABAuthorizationStatus.NotDetermined) {
            let addressBook: ABAddressBookRef? = SimpleAB.createAddressBook()
            ABAddressBookRequestAccessWithCompletion(addressBook, { (success, error) -> Void in
                completion(status: authorizationStatus, success: success, error: error)
            })
        } else if (authorizationStatus == ABAuthorizationStatus.Denied || authorizationStatus == ABAuthorizationStatus.Restricted) {
            completion(status: authorizationStatus, success: false, error: nil)
        } else if (authorizationStatus == ABAuthorizationStatus.Authorized) {
            completion(status: authorizationStatus, success: true, error: nil)
        }
    }
}


class NTHAddressBookViewController: UITableViewController {

    private var contacts = Array<SimpleAB.Record>()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadContacts()
    }
    
    private func loadContacts() {
        /// Check authorization status
        SimpleAB.checkAuthorizationStatus { (status, success, error) -> Void in
            if (success) {
                var fetchedContacts: [ABRecordRef] = ABAddressBookCopyArrayOfAllPeople(SimpleAB.createAddressBook()).takeRetainedValue()
                
                for record in fetchedContacts {
                    self.contacts.append(SimpleAB.Record(record: record))
                }
                
                self.tableView.reloadData()
            } else {
                /// Display alert
                let alert = UIAlertController(title: NSLocalizedString("Address Book", comment: ""), message: NSLocalizedString("Cannot access Address Book", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
                
                let closeAction = UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    
                })
                
                alert.addAction(closeAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NTHAddressBookCell") as NTHAddressBookCell
        cell.label.text = self.contacts[indexPath.row].name
        
        return cell
    }
}
