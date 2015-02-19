//
//  NTHCreateEditTaskViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 15/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import CoreData

class TaskContainer {
    var title: String?
    var locationReminders = [LocationReminderInfo]()
    var dateReminders = [DateReminderInfo]()
    var links = [Connection]()
}

class NTHCreateEditTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    @IBOutlet private weak var scrollViewBottomGuide: NSLayoutConstraint!
    @IBOutlet private weak var titleTextField: NTHTextField!
    
    @IBOutlet private weak var locationsTableView: UITableView!
    @IBOutlet private weak var locationsTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var datesTableView: UITableView!
    @IBOutlet private weak var datesTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var linksTableView: UITableView!
    @IBOutlet private weak var linksTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var notesTextView: NTHPlaceholderTextView!
    
    @IBOutlet private var tapGesture: UITapGestureRecognizer!
    
    @IBOutlet private var doneButton: UIBarButtonItem!

    /**
        For setting UI colors
    */
    @IBOutlet private weak var locationRemindersLabel: UILabel!
    @IBOutlet private weak var dateRemindersLabel: UILabel!
    @IBOutlet private weak var linksLabel: UILabel!
    @IBOutlet private weak var separator1: UIView!
    @IBOutlet private weak var separator2: UIView!
    @IBOutlet private weak var separator3: UIView!
    @IBOutlet private weak var separator4: UIView!
    /// END
    
    

    private var taskContainer = TaskContainer()

    enum TableViewType: Int {
        case Locations, Dates, Links
    }
    
    private enum SegueIdentifier: String {
        case CreateLocationReminder = "CreateLocationReminder"
        case EditLocationReminder = "EditLocationReminder"
        case CreateDateReminder = "CreateDateReminder"
        case EditDateReminder = "EditDateReminder"
        case AddPlaceLink = "AddPlaceLink"
        case AddContactLink = "AddContactLink"
    }
    
    
    var context: NSManagedObjectContext!
    var completionBlock: (() -> Void)?
    
    
    override func viewDidLoad() {
                
        super.viewDidLoad()
        self._configureColors()
        self._configureTitleTextField()
        
        /// Register center label cell=
        let centerCellIdentifier = "NTHCenterLabelCell"
        let leftLabelRemoveCellIdentifier = "NTHLeftLabelRemoveCell"
        
        self.locationsTableView.registerNib(centerCellIdentifier)
        self.locationsTableView.registerNib(leftLabelRemoveCellIdentifier)
        
        self.datesTableView.registerNib(centerCellIdentifier)
        self.datesTableView.registerNib(leftLabelRemoveCellIdentifier)
        
        self.linksTableView.registerNib(centerCellIdentifier)
        self.linksTableView.registerNib(leftLabelRemoveCellIdentifier)
        
        self._configureLocationsTableView()
        self._configureDatesTableView()
        self._configureLinksTableView()
    }
    
    private func _addObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldDidChange:", name: UITextFieldTextDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private func _removeObservers() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.scrollViewBottomGuide.constant = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.scrollViewBottomGuide.constant = 0
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func textFieldDidChange(notification: NSNotification) {
        if (notification.object as! UITextField == self.titleTextField) {
            self._validateDoneButton()
        }
    }

    
    private func _configureColors() {
        self.locationRemindersLabel.textColor = UIColor.NTHHeaderTextColor()
        self.dateRemindersLabel.textColor = UIColor.NTHHeaderTextColor()
        self.linksLabel.textColor = UIColor.NTHHeaderTextColor()
        
        self.separator1.backgroundColor = UIColor.NTHTableViewSeparatorColor()
        self.separator2.backgroundColor = UIColor.NTHTableViewSeparatorColor()
        self.separator3.backgroundColor = UIColor.NTHTableViewSeparatorColor()
        self.separator4.backgroundColor = UIColor.NTHTableViewSeparatorColor()
        
        self.notesTextView.placeholderColor = UIColor.NTHPlaceholderTextColor()
    }
    
    private func _configureTitleTextField() {
        self.titleTextField.textFieldDidChangeBlock = { text in
            self.taskContainer.title = text
        }
    }
    
    private func _configureLocationsTableView() {
        self.locationsTableView.tag = TableViewType.Locations.rawValue
    }
    
    private func _configureDatesTableView() {
        self.datesTableView.tag = TableViewType.Dates.rawValue
    }
    
    private func _configureLinksTableView() {
        self.linksTableView.tag = TableViewType.Links.rawValue
    }

    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self._addObservers()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self._removeObservers()
    }
    
    @IBAction func handleTap(sender: AnyObject) {
        if self.titleTextField.isFirstResponder() || self.notesTextView.isFirstResponder() {
            self.titleTextField.resignFirstResponder()
            self.notesTextView.resignFirstResponder()
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.CreateLocationReminder.rawValue {
            let vc = segue.destinationViewController as! NTHCreateEditLocationReminderViewController
            vc.context = self.context
            vc.completionBlock = { newReminder in
                self.taskContainer.locationReminders.append(newReminder)
                self._refreshTableView(self.locationsTableView, heightConstraint: self.locationsTableViewHeight, items: self.taskContainer.locationReminders.count + 1)
            }
        } else if segue.identifier == SegueIdentifier.EditLocationReminder.rawValue {
            let reminder = sender as! LocationReminderInfo
            let vc = segue.destinationViewController as! NTHCreateEditLocationReminderViewController
            vc.context = self.context
            vc.editedReminder = reminder
            vc.completionBlock = { newReminder in
                self._refreshTableView(self.locationsTableView, heightConstraint: self.locationsTableViewHeight, items: self.taskContainer.locationReminders.count + 1)
                self._refreshTableView(self.linksTableView, heightConstraint: self.linksTableViewHeight, items: self.taskContainer.links.count + 1)
            }
        } else if segue.identifier == SegueIdentifier.CreateDateReminder.rawValue {
            let vc = segue.destinationViewController as! NTHCreateEditDateReminderViewController
            vc.context = self.context
            vc.completionBlock = { newReminder in
                self.taskContainer.dateReminders.append(newReminder)
                self._refreshTableView(self.datesTableView, heightConstraint: self.datesTableViewHeight, items: 1)
            }
        } else if segue.identifier == SegueIdentifier.EditDateReminder.rawValue {
            let vc = segue.destinationViewController as! NTHCreateEditDateReminderViewController
            vc.context = self.context
            let reminder = sender as! DateReminderInfo
            vc.editedReminder = reminder
            vc.completionBlock = { newReminder in
                self._refreshTableView(self.datesTableView, heightConstraint: self.datesTableViewHeight, items: 1)
            }
        } else if segue.identifier == SegueIdentifier.AddPlaceLink.rawValue {
            let vc = segue.destinationViewController as! NTHSelectPlaceViewController
            vc.context = self.context
            vc.completionBlock = { selectedPlace in
                self.taskContainer.links.append(selectedPlace)
                self._refreshTableView(self.linksTableView, heightConstraint: self.linksTableViewHeight, items: self.taskContainer.links.count + 1)
            }
        } else if segue.identifier == SegueIdentifier.AddContactLink.rawValue {
            let vc = segue.destinationViewController as! NTHSelectContactViewController
            vc.context = self.context
            vc.completionBlock = { selectedContact in
                self.taskContainer.links.append(selectedContact)
                self._refreshTableView(self.linksTableView, heightConstraint: self.linksTableViewHeight, items: self.taskContainer.links.count + 1)
            }
        }
    }
    
    private func _validateDoneButton() {
        self.doneButton.enabled = count(self.titleTextField.text) > 0
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        let task: Task = Task.create(self.context)
        task.uniqueIdentifier = NSUUID().UUIDString
        task.title = self.taskContainer.title!
        
        task.locationReminderInfo = self.taskContainer.locationReminders.first
        task.dateReminderInfo = self.taskContainer.dateReminders.first
        task.connections = NSSet(array: self.taskContainer.links)
        
        task.longDescription = self.notesTextView.textValue
        
        self.context.save(nil)
        self.context.parentContext?.save(nil)
        self.completionBlock?()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    

    /// Mark: UITableViewDelegate & UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView.type {
        case .Locations:
            return self.taskContainer.locationReminders.count + 1
            
        case .Dates:
            return 1
            
        case .Links:
            return self.taskContainer.links.count + 1
        }
    }
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        func _createAddNewSomethingCell(title: String) -> NTHCenterLabelCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHCenterLabelCell") as! NTHCenterLabelCell
            cell.label.font = UIFont(name: "AvenirNext-Regular", size: 14.0)
            cell.label.text = title
            cell.selectedBackgroundView = UIView()
            return cell
        }
        
        func _createRegularCell(title: String) -> NTHLeftLabelRemoveCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHLeftLabelRemoveCell") as! NTHLeftLabelRemoveCell
            cell.label.font = UIFont(name: "AvenirNext-Regular", size: 18.0)
            cell.label.text = title
            cell.selectedBackgroundView = UIView()
            return cell
        }
        
        switch tableView.type {
        case .Locations:
            if indexPath.row == self.taskContainer.locationReminders.count {
                return _createAddNewSomethingCell("+ Add new location")
            } else {
                let cell = _createRegularCell(self.taskContainer.locationReminders[indexPath.row].place.customName)
                cell.clearPressedBlock = { cell in
                    self.taskContainer.locationReminders.removeAtIndex(self.locationsTableView.indexPathForCell(cell)!.row)
                    self._refreshTableView(self.locationsTableView, heightConstraint: self.locationsTableViewHeight, items: self.taskContainer.locationReminders.count + 1)
                }
                return cell
            }
        case .Dates:
            if indexPath.row == self.taskContainer.dateReminders.count {
                return _createAddNewSomethingCell("+ Add new date")
            } else {
                let reminder = self.taskContainer.dateReminders[indexPath.row]
                let title = NSDateFormatter.NTHStringFromDate(reminder.fireDate)
                let cell = _createRegularCell(title)
                cell.clearPressedBlock = { cell in
                    self.taskContainer.dateReminders.removeAtIndex(self.datesTableView.indexPathForCell(cell)!.row)
                    self._refreshTableView(self.datesTableView, heightConstraint: self.datesTableViewHeight, items: 1)
                }
                return cell
            }
        case .Links:
            if indexPath.row == self.taskContainer.links.count {
                return _createAddNewSomethingCell("+ Add new link")
            } else {
                let title: String
                let link = self.taskContainer.links[indexPath.row]
                if link is Place {
                    title = (link as! Place).customName
                } else {
                    title = (link as! Contact).name
                }
                
                let cell = _createRegularCell(title)
                cell.clearPressedBlock = { cell in
                    self.taskContainer.links.removeAtIndex(self.linksTableView.indexPathForCell(cell)!.row)
                    self._refreshTableView(self.linksTableView, heightConstraint: self.linksTableViewHeight, items: self.taskContainer.links.count + 1)
                }
                return cell
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.tableViewCellHeight()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch tableView.type {
        case .Locations:
            let addNewReminder = indexPath.row == self.taskContainer.locationReminders.count
            if addNewReminder {
                self.performSegueWithIdentifier(SegueIdentifier.CreateLocationReminder.rawValue, sender: nil)
            } else {
                var reminder = self.taskContainer.locationReminders[indexPath.row]
                self.performSegueWithIdentifier(SegueIdentifier.EditLocationReminder.rawValue, sender: reminder)
            }
            
        case .Dates:
            let addNewReminder = indexPath.row == self.taskContainer.dateReminders.count
            if addNewReminder {
                self.performSegueWithIdentifier(SegueIdentifier.CreateDateReminder.rawValue, sender: nil)
            } else {
                var reminder = self.taskContainer.dateReminders[indexPath.row]
                self.performSegueWithIdentifier(SegueIdentifier.EditDateReminder.rawValue, sender: reminder)
            }
            
        case .Links:
            let addNewLink = indexPath.row == self.taskContainer.links.count
            if addNewLink {
                let types = [
                    "contact": NSLocalizedString("Contact", comment: ""),
                    "place": NSLocalizedString("Place", comment: "")
                ]
                
                let alert = UIAlertController.selectConnectionTypeActionSheet(types, completion: { (action: NTHAlertAction) -> Void in
                    if action.identifier == "contact" {
                        self.performSegueWithIdentifier(SegueIdentifier.AddContactLink.rawValue, sender: nil)
                    } else if action.identifier == "place" {
                        self.performSegueWithIdentifier(SegueIdentifier.AddPlaceLink.rawValue, sender: nil)
                    }
                })
                
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                
            }
            
        default:
            break
        }
    }
    
    private func _refreshTableView(tableView: UITableView, heightConstraint: NSLayoutConstraint, items: Int) {
        /// Update table view height
        let height = CGFloat(items) * self.tableViewCellHeight()
        heightConstraint.constant = height
        
        UIView.animateWithDuration(NSTimeInterval(0.3), animations: {
            self.view.needsUpdateConstraints()
            tableView.reloadData()
            return /// explicit return
        })
    }
    
    private func tableViewCellHeight() -> CGFloat {
        return 50.0
    }
    
    
    /// Mark: UIGestureRecognizerDelegate
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if self.titleTextField.isFirstResponder() || self.notesTextView.isFirstResponder() {
            return true
        }
        
        return false
    }
}

private extension UITableView {
    var type: NTHCreateEditTaskViewController.TableViewType {
        return NTHCreateEditTaskViewController.TableViewType(rawValue: self.tag)!
    }
}

class NTHAlertAction : UIAlertAction {
    var identifier: String!
}

private extension UIAlertController {
    class func selectConnectionTypeActionSheet(types: [String: String], completion:(action: NTHAlertAction) -> Void) -> UIAlertController {
        /// Create alert
        let alert = UIAlertController(title: NSLocalizedString("Links", comment:""), message: NSLocalizedString("What type of link do you want to add?", comment:""), preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        /// Fill it with types
        for (identifier, description) in types {
            let action = NTHAlertAction(title: description, style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                completion(action: action as! NTHAlertAction)
            })
            action.identifier = identifier
            alert.addAction(action)
        }
        
        /// Add cancel
        let action = NTHAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(action)
        
        return alert
    }
}

