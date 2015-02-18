//
//  NTHSelectContactViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 18/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import CoreData

class NTHSelectContactViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    private var selectedIndexPath: NSIndexPath?
    private var contacts = [Contact]()
    
    private enum SegueIdentifier: String {
        case AddNewContact = "AddNewContact"
    }
    
    
    var context: NSManagedObjectContext!
    var completionBlock: ((selectedContact: Contact) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib("NTHCenterLabelCell")
        self.tableView.registerNib("NTHLeftLabelCell")
        self.contacts = ModelController().allContacts(self.context)
    }
    
    private func _validateDoneButton() {
        self.doneButton.enabled = self.selectedIndexPath != nil
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        self.completionBlock?(selectedContact: self.contacts[selectedIndexPath!.row])
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.AddNewContact.rawValue {
            let vc = segue.destinationViewController as! NTHCreateEditContactViewController
            vc.context = self.context
            vc.completionBlock = {
                self.contacts = ModelController().allContacts(self.context)
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    
    /// Mark: Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == self.contacts.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHCenterLabelCell") as! NTHCenterLabelCell
            cell.label.text = "+ Add new contact"
            cell.label.font = UIFont.NTHAddNewCellFont()
            cell.selectedBackgroundView = UIView()
            return cell
        } else {
            let contact = self.contacts[indexPath.row]
            
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHLeftLabelCell") as! NTHLeftLabelCell
            
            cell.label.text = contact.name
            cell.label.font = UIFont.NTHNormalTextFont()
            cell.selectedBackgroundView = UIView()
            cell.tintColor = UIColor.NTHNavigationBarColor()
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if indexPath.row == self.contacts.count {
            /// show contact wizard
            self.performSegueWithIdentifier(SegueIdentifier.AddNewContact.rawValue, sender: nil)
        } else {
            /// deselect old cell
            if let previousIndexPath = self.selectedIndexPath {
                let previousCell = tableView.cellForRowAtIndexPath(previousIndexPath) as! NTHLeftLabelCell
                previousCell.accessoryType = .None
            }
            
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! NTHLeftLabelCell
            if cell.accessoryType == .None {
                cell.accessoryType = .Checkmark
                self.selectedIndexPath = indexPath
            } else {
                cell.accessoryType = .None
            }
        }
        
        self._validateDoneButton()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
}
