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
    
    @IBOutlet weak var scrollViewBottomGuide: NSLayoutConstraint!
    @IBOutlet private weak var titleTextField: NTHTextField!
    
    @IBOutlet private weak var locationsTableView: UITableView!
    @IBOutlet weak var locationsTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var datesTableView: UITableView!
    @IBOutlet private weak var datesTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var linksTableView: UITableView!
    @IBOutlet weak var linksTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var notesTextView: NTHPlaceholderTextView!
    
    @IBOutlet private var tapGesture: UITapGestureRecognizer!
    
    
    /**
        For setting UI colors
    */
    @IBOutlet weak var locationRemindersLabel: UILabel!
    @IBOutlet weak var dateRemindersLabel: UILabel!
    @IBOutlet weak var linksLabel: UILabel!
    @IBOutlet weak var separator1: UIView!
    @IBOutlet weak var separator2: UIView!
    @IBOutlet weak var separator3: UIView!
    @IBOutlet weak var separator4: UIView!
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
    }
    
    
    var context: NSManagedObjectContext!
    
    
    override func viewDidLoad() {
        
        self.context = CDHelper.temporaryContext
        
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
//                self.taskContainer.links.append((newReminder as LocationReminderInfo).place)
                self._refreshTableView(self.locationsTableView, heightConstraint: self.locationsTableViewHeight, items: self.taskContainer.locationReminders.count + 1)
//                self._refreshTableView(self.linksTableView, heightConstraint: self.linksTableViewHeight, items: self.taskContainer.links.count + 1)
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
        }
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

extension UITableView {
    var type: NTHCreateEditTaskViewController.TableViewType {
        return NTHCreateEditTaskViewController.TableViewType(rawValue: self.tag)!
    }
}
