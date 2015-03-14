//
//  NTHCreateEditTaskViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 15/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import CoreData

class NTHCreateEditTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    @IBOutlet private weak var scrollView: UIScrollView!
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
    @IBOutlet private weak var cancelButton: UIBarButtonItem!
    
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
        case AddLocationDateReminder = "AddLocationDateReminder"
        case EditLocationDateReminder = "EditLocationDateReminder"
    }
    
    
    var context: NSManagedObjectContext!
    var completionBlock: ((task: Task) -> Void)?
    var task: Task!
    
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
        
        self.locationsTableView.tag = TableViewType.Locations.rawValue
        self.datesTableView.tag = TableViewType.Dates.rawValue
        self.linksTableView.tag = TableViewType.Links.rawValue
        
        if self.task == nil {
            self.task = Task.create(self.context) as Task
            self.task.uniqueIdentifier = NSUUID().UUIDString
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.titleTextField.text = self.task.title
        if count(self.task.longDescription ?? "") > 0 {
            self.notesTextView.text = task.longDescription!
        }
        
        self._validateDoneButton()
        self._refreshLocations()
        self._refreshDates()
        self._refreshLinks()
        
        self._addObservers()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self._removeObservers()
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
        
        if self.titleTextField.isFirstResponder() {
            self.scrollView.scrollRectToVisible(self.titleTextField.frame, animated: true)
        } else if self.notesTextView.isFirstResponder() {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: CGRectGetMinY(self.notesTextView.frame) - 140.0), animated: true)
        }
        
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
            self.task.title = text
        }
    }
    
    @IBAction func handleTap(sender: AnyObject) {
        if self.titleTextField.isFirstResponder() || self.notesTextView.isFirstResponder() {
            self.titleTextField.resignFirstResponder()
            self.notesTextView.resignFirstResponder()
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.CreateLocationReminder.rawValue {
            let vc = segue.topOfNavigationController as! NTHCreateEditLocationReminderViewController
            vc.context = CDHelper.temporaryContextWithParent(self.context)
            vc.completionBlock = { newReminder in
                let object = self.context.objectWithID(newReminder.objectID)
                let reminder = object as! LocationReminder
                self.task.addReminder(reminder)
                self._refreshLocations()
            }
        } else if segue.identifier == SegueIdentifier.EditLocationReminder.rawValue {
            let reminder = sender as! LocationReminder
            let vc = segue.topOfNavigationController as! NTHCreateEditLocationReminderViewController
            vc.context = self.context
            vc.reminder = reminder
            vc.completionBlock = { newReminder in
                self._refreshLocations()
                self._refreshLinks()
            }
        } else if segue.identifier == SegueIdentifier.CreateDateReminder.rawValue {
            let vc = segue.topOfNavigationController as! NTHCreateEditDateReminderViewController
            vc.context = CDHelper.temporaryContextWithParent(self.context)
            vc.completionBlock = { newReminder in
                let object = self.context.objectWithID(newReminder.objectID)
                let reminder = object as! DateReminder
                self.task.addReminder(reminder)
                self._refreshDates()
            }
        } else if segue.identifier == SegueIdentifier.EditDateReminder.rawValue {
            let vc = segue.topOfNavigationController as! NTHCreateEditDateReminderViewController
            vc.context = CDHelper.temporaryContextWithParent(self.context)
            vc.reminder = vc.context.objectWithID((sender as! DateReminder).objectID) as! DateReminder
            vc.completionBlock = { newReminder in
                self._refreshDates()
            }
        } else if segue.identifier == SegueIdentifier.AddPlaceLink.rawValue {
            let vc = segue.destinationViewController as! NTHSimpleSelectLinkViewController
            vc.linkType = LinkType.Place
            vc.context = self.context
            vc.links = ModelController().allPlaces(self.context)
            vc.completionBlock = { selectedPlace in
                self.task.addLink(selectedPlace)
                self._refreshLinks()
            }
        } else if segue.identifier == SegueIdentifier.AddContactLink.rawValue {
            let vc = segue.destinationViewController as! NTHSimpleSelectLinkViewController
            vc.linkType = LinkType.Contact
            vc.context = self.context
            vc.links = ModelController().allContacts(self.context)
            vc.completionBlock = { selectedContact in
                self.task.addLink(selectedContact)
                self._refreshLinks()
            }
        }
    }
    
    private func _refreshLinks() {
        let height = CGFloat(self.task.links.count + 1) * self.tableViewCellHeight()
        self.linksTableView.refreshTableView(self.linksTableViewHeight, height: height)
    }
    
    private func _refreshDates() {
        let height = CGFloat(self.task.dateReminders.count + 1) * self.tableViewCellHeight()
        self.datesTableView.refreshTableView(self.datesTableViewHeight, height: height)
    }
    
    private func _refreshLocations() {
        let height = CGFloat(self.task.locationReminders.count + 1) * self.tableViewCellHeight()
        self.locationsTableView.refreshTableView(self.locationsTableViewHeight, height: height)
    }
    
    private func _validateDoneButton() {
        self.doneButton.enabled = count(self.titleTextField.text) > 0
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        self.task.title = self.titleTextField.text
        self.task.longDescription = self.notesTextView.textValue
        self.context.save(nil)
        self.completionBlock?(task: self.task)
        self.task.schedule()
        
        /// Notify TSRegionManager that place changed
        NSNotificationCenter.defaultCenter().postNotificationName(AppDelegate.ApplicationDidUpdatePlaceSettingsNotification, object: nil)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    /// Mark: UITableViewDelegate & UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.type {
        case .Locations:
            return self.task.locationReminders.count + 1
            
        case .Dates:
            return self.task.dateReminders.count + 1
            
        case .Links:
            return self.task.links.allObjects.count + 1
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
            cell.label.font = UIFont.NTHNormalTextFont()
            cell.label.text = title
            cell.selectedBackgroundView = UIView()
            return cell
        }
        
        switch tableView.type {
        case .Locations:
            let reminders = self.task.locationReminders
            if indexPath.row == reminders.count {
                return _createAddNewSomethingCell("+ Add reminder")
            } else {
                let reminder = reminders[indexPath.row]
                let cell = _createRegularCell(reminder.place.name)
                cell.clearPressedBlock = { cell in
                    self.task.removeReminder(reminder)
                    self._refreshLocations()
                }
                return cell
            }
            
        case .Dates:
            if indexPath.row == self.task.dateReminders.count {
                return _createAddNewSomethingCell("+ Add reminder")
            } else {
                let reminders = self.task.dateReminders
                let reminder = reminders[indexPath.row]
                let title = NSDateFormatter.NTHStringFromDate(reminder.fireDate)
                let cell = _createRegularCell(title)
                cell.clearPressedBlock = { cell in
                    self.task.removeReminder(reminder)
                    self._refreshDates()
                }
                return cell
            }
            
        case .Links:
            if indexPath.row == self.task.links.allObjects.count {
                return _createAddNewSomethingCell("+ Add new link")
            } else {
                let title: String
                let link = self.task.links.allObjects[indexPath.row] as! Link
                if link is Place {
                    title = (link as! Place).name
                } else {
                    title = (link as! Contact).name
                }
                
                let cell = _createRegularCell(title)
                cell.clearPressedBlock = { cell in
                    self.task.removeLink(link)
                    self._refreshLinks()
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
            let reminders = self.task.locationReminders
            if indexPath.row == reminders.count {
                self.performSegueWithIdentifier(SegueIdentifier.CreateLocationReminder.rawValue, sender: nil)
            } else {
                var reminder = reminders[indexPath.row]
                self.performSegueWithIdentifier(SegueIdentifier.EditLocationReminder.rawValue, sender: reminder)
            }
            
        case .Dates:
            let reminders = self.task.dateReminders
            if indexPath.row == reminders.count {
                self.performSegueWithIdentifier(SegueIdentifier.CreateDateReminder.rawValue, sender: nil)
            } else {
                self.performSegueWithIdentifier(SegueIdentifier.EditDateReminder.rawValue, sender: reminders[indexPath.row])
            }
            
        case .Links:
            let addNewLink = indexPath.row == self.task.links.allObjects.count
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

