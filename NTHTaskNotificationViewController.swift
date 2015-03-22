//
//  NTHTaskNotificationViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 22/03/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import CoreData

class NTHTaskNotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var titleField: NTHTextField!
    @IBOutlet weak var locationRemindersTableView: UITableView!
    @IBOutlet weak var locationRemindersTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var dateRemindersTableView: UITableView!
    @IBOutlet weak var dateRemindersTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var linkRemindersTableView: UITableView!
    @IBOutlet weak var linkRemindersTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var noteTextView: NTHPlaceholderTextView!

    @IBOutlet var statusButton: UIBarButtonItem!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet var snoozeButton: UIBarButtonItem!
    @IBOutlet weak var taskStatusView: NTHTaskStatusView!
    
    private enum TableViewType: Int {
        case Locations, Dates, Links
    }
    
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notSetCellIdentifier = "NTHCenterLabelCell"
        let twoLineLeftLabelCellIdentifier = "NTHTwoLineLeftLabelCell"
        self.locationRemindersTableView.tag = TableViewType.Locations.rawValue
        self.locationRemindersTableView.registerNib(notSetCellIdentifier)
        self.locationRemindersTableView.registerNib(twoLineLeftLabelCellIdentifier)
        
        self.dateRemindersTableView.tag = TableViewType.Dates.rawValue
        self.dateRemindersTableView.registerNib(notSetCellIdentifier)
        self.dateRemindersTableView.registerNib(twoLineLeftLabelCellIdentifier)
        
        self.linkRemindersTableView.tag = TableViewType.Links.rawValue
        self.linkRemindersTableView.registerNib(notSetCellIdentifier)
        self.linkRemindersTableView.registerNib("NTHLeftLabelCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self._fillView()
        self.taskStatusView.state = self.task.state
    }
    
    
    private func _fillView() {
        self.titleField.text = self.task.title
        if count(self.task.longDescription ?? "") > 0 {
            self.noteTextView.text = self.task.longDescription!
        }
        
        self.locationRemindersTableView.refreshTableView(self.locationRemindersTableViewHeight, height: self._locationRemindersTableViewHeight())
        self.dateRemindersTableView.refreshTableView(self.dateRemindersTableViewHeight, height: self._datesRemindersTableViewHeight())
        self.linkRemindersTableView.refreshTableView(self.linkRemindersTableViewHeight, height: self._linksTableViewHeight())
    }
    
    
    /// MARK: Actions
    
    @IBAction func closePressed(sender: AnyObject) {
        var window: UIWindow! = UIApplication.sharedApplication().keyWindow!
        window.hidden = true
        window.resignKeyWindow()
        window = nil
    }

    @IBAction func snoozePressed(sender: AnyObject) {
        
    }
    
    @IBAction func statusPressed(sender: AnyObject) {
        self.task.changeState()
        self.taskStatusView.state = self.task.state
        self.task.managedObjectContext!.save(nil)
        self.task.managedObjectContext!.parentContext?.save(nil)
        
        /// Notify TSRegionManager that place changed
        NSNotificationCenter.defaultCenter().postNotificationName(AppDelegate.ApplicationDidUpdatePlaceSettingsNotification, object: nil)
    }
    
    /// MARK: TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch TableViewType(rawValue:tableView.tag)! {
        case .Locations: return max(1, self.task.locationReminders.count)
        case .Dates: return max(1, self.task.dateReminders.count)
        case .Links: return max(1, self.task.links.allObjects.count)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        func _createNotSetCell(title: String) -> NTHCenterLabelCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHCenterLabelCell") as! NTHCenterLabelCell
            cell.label.font = UIFont.NTHAddNewCellFont()
            cell.label.text = title
            cell.label.textColor = UIColor.NTHSubtitleTextColor()
            cell.selectedBackgroundView = UIView()
            return cell
        }
        
        func _createTwoLabelCell(topText: String, bottomText: String) -> NTHTwoLineLeftLabelCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHTwoLineLeftLabelCell") as! NTHTwoLineLeftLabelCell
            cell.topLabel.font = UIFont.NTHNormalTextFont()
            cell.topLabel.text = topText
            
            cell.bottomLabel.font = UIFont.NTHAddNewCellFont()
            cell.bottomLabel.text = bottomText
            
            cell.selectedBackgroundView = UIView()
            return cell
        }
        
        func _createRegularCell(title: String) -> NTHLeftLabelCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHLeftLabelCell") as! NTHLeftLabelCell
            cell.label.font = UIFont.NTHNormalTextFont()
            cell.label.text = title
            cell.selectedBackgroundView = UIView()
            return cell
        }
        
        switch TableViewType(rawValue:tableView.tag)! {
        case .Locations:
            let reminders = self.task.locationReminders
            if indexPath.row != reminders.count {
                let reminder = reminders[indexPath.row]
                let topText = reminder.place.name
                let prefix = reminder.onArrive.boolValue ? "Arrive" : "Leave"
                let bottomText = prefix + ", " + reminder.distance.floatValue.metersOrKilometers()
                
                return _createTwoLabelCell(topText, bottomText)
            } else {
                return _createNotSetCell("No reminders")
            }
            
        case .Dates:
            let reminders = self.task.dateReminders
            if reminders.count > 0 {
                let reminder = reminders[indexPath.row]
                let topText = NSDateFormatter.NTHStringFromDate(reminder.fireDate)
                let bottomText = RepeatInterval.descriptionForInterval(interval: reminder.repeatInterval)
                return _createTwoLabelCell(topText, bottomText)
            } else {
                return _createNotSetCell("No reminders")
            }
            
        case .Links:
            if self.task.links.allObjects.count > 0 {
                let link = self.task.links.allObjects[indexPath.row] as! Link
                
                let name: String!
                if link is Contact {
                    name = (link as! Contact).name
                } else {
                    name = (link as! Place).name
                }
                
                return _createRegularCell(name)
            } else {
                return _createNotSetCell("No links")
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch TableViewType(rawValue:tableView.tag)! {
        case .Locations:
            let reminders = self.task.locationReminders
            if reminders.count > 0 {
                let reminder = reminders[indexPath.row]
                let alert = UIAlertController.actionSheetForPlace(reminder.place)
                self.presentViewController(alert, animated: true, completion: nil)
            }
            break
            
        case .Dates:
            break
            
        case .Links:
            if self.task.links.allObjects.count > 0 {
                let link = self.task.links.allObjects[indexPath.row] as! Link
                if link is Place {
                    let alert = UIAlertController.actionSheetForPlace(link as! Place)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else if link is Contact {
                    let alert = UIAlertController.actionSheetForContact(link as! Contact)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            break
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch TableViewType(rawValue:tableView.tag)! {
        case .Locations:
            return self.task.locationReminders.count > 0 ? self._twoLineCellHeight() : self._oneLineCellHeight()
        case .Dates:
            return (self.task.dateReminders.count > 0) ? self._twoLineCellHeight() : self._oneLineCellHeight()
            
        case .Links:
            return self._oneLineCellHeight()
        }
    }
    
    
    private func _oneLineCellHeight() -> CGFloat {
        return 50.0
    }
    
    private func _twoLineCellHeight() -> CGFloat {
        return 69.0
    }
    
    private func _locationRemindersTableViewHeight() -> CGFloat {
        let count = self.task.locationReminders.count
        return count > 0 ? CGFloat(count) * self._twoLineCellHeight() : self._oneLineCellHeight()
    }
    
    private func _datesRemindersTableViewHeight() -> CGFloat {
        let count = self.task.dateReminders.count
        return (count > 0) ? self._twoLineCellHeight() * CGFloat(count) : self._oneLineCellHeight()
    }
    
    private func _linksTableViewHeight() -> CGFloat {
        return self._oneLineCellHeight() * CGFloat(max(1, self.task.links.count))
    }

}
