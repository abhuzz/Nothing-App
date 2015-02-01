//
//  NTHSelectContactViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 01/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHSelectContactViewController: UITableViewController {
    
    typealias NTHSelectContactViewController = (contact: Contact) -> Void
    
    enum SegueIdentifier: String {
        case AddressBook = "AddressBook"
    }
    
    var selectionBlock: NTHSelectContactViewController?
    
    private var contacts = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.contacts = ModelController().allContacts()
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
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHContactCell") as NTHContactCell
            cell.label.text = self.contacts[indexPath.row].name
            return cell
        } else {
            return tableView.dequeueReusableCellWithIdentifier("NTHAddNewContactCell") as NTHAddNewContactCell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row != self.numberOfCells() - 1 {
            self.selectionBlock?(contact: self.contacts[indexPath.row])
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.performSegueWithIdentifier(SegueIdentifier.AddressBook.rawValue, sender: nil)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
}
