//
//  NTHSelectContactViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 01/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import AddressBook
import AddressBookUI
import CoreData

class NTHSelectContactViewController: UITableViewController, ABPeoplePickerNavigationControllerDelegate, UINavigationControllerDelegate {
    
    typealias NTHSelectContactViewController = (contact: Contact) -> Void
    
    var selectionBlock: NTHSelectContactViewController?
    var context: NSManagedObjectContext!
    
    private var contacts = [Contact]()
    private var pickerController: ABPeoplePickerNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        
        let centerLabelNib = UINib(nibName: "NTHCenterLabelCell", bundle: nil)
        self.tableView.registerNib(centerLabelNib, forCellReuseIdentifier: "NTHCenterLabelCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.contacts = ModelController().allContacts(self.context)
        self.tableView.reloadData()
    }
    
    @IBAction func closePressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func numberOfCells() -> Int {
        return self.contacts.count + 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfCells()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row != self.numberOfCells() - 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHContactCell") as! NTHContactCell
            cell.label.text = self.contacts[indexPath.row].name
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHCenterLabelCell") as! NTHCenterLabelCell
            cell.label.text = String.addANewContactString()
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row != self.numberOfCells() - 1 {
            self.selectionBlock?(contact: self.contacts[indexPath.row])
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            /// self.performSegueWithIdentifier(SegueIdentifier.AddressBook.rawValue, sender: nil)
            
            if self.pickerController == nil {
                self.pickerController = ABPeoplePickerNavigationController()
                self.pickerController?.peoplePickerDelegate = self
            }
            
            self.presentViewController(self.pickerController!, animated: true, completion: nil)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    
    // Mark: ABPeoplePickerNavigationControllerDelegate
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson person: ABRecord!) {
        let contact: Contact = Contact.create(self.context)
        contact.name = ABRecordCopyCompositeName(person).takeRetainedValue() as String
        contact.phone = "+48555123456"
        contact.email = "mail@szulctomasz.com"
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, shouldContinueAfterSelectingPerson person: ABRecord!, property: ABPropertyID, identifier: ABMultiValueIdentifier) -> Bool {
        return false
    }
}
