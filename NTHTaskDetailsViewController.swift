//
//  NTHTaskDetailsViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 19/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import CoreData

class NTHTaskDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
    
    @IBOutlet private weak var locationRemindersLabel: UILabel!
    @IBOutlet private weak var dateRemindersLabel: UILabel!
    @IBOutlet private weak var linksLabel: UILabel!
    @IBOutlet private weak var separator1: UIView!
    @IBOutlet private weak var separator2: UIView!
    @IBOutlet private weak var separator3: UIView!
    @IBOutlet private weak var separator4: UIView!
    
    @IBOutlet private weak var markButton: NTHButton!
    @IBOutlet weak var taskStatusView: NTHTaskStatusView!

    var task: Task!
    var context: NSManagedObjectContext!
    var completionBlock: (() -> Void)?
    
    enum TableViewType: Int {
        case Locations, Dates, Links
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._configureColors()
        
        
        let notSetCellIdentifier = "NTHCenterLabelCell"
        let twoLineLeftLabelCellIdentifier = "NTHTwoLineLeftLabelCell"
        self.locationsTableView.tag = TableViewType.Locations.rawValue
        self.locationsTableView.registerNib(notSetCellIdentifier)
        self.locationsTableView.registerNib(twoLineLeftLabelCellIdentifier)
        
        self.datesTableView.tag = TableViewType.Dates.rawValue
        self.datesTableView.registerNib(notSetCellIdentifier)
        self.datesTableView.registerNib(twoLineLeftLabelCellIdentifier)

        self.linksTableView.tag = TableViewType.Links.rawValue
        self.linksTableView.registerNib(notSetCellIdentifier)
        self.linksTableView.registerNib("NTHLeftLabelCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self._fillView()
        self._refreshTableView(self.locationsTableView, heightConstraint: self.locationsTableViewHeight, height: self._locationRemindersTableViewHeight())
        self._refreshTableView(self.datesTableView, heightConstraint: self.datesTableViewHeight, height: self._datesRemindersTableViewHeight())
        self._refreshTableView(self.linksTableView, heightConstraint: self.linksTableViewHeight, height: self._linksTableViewHeight())
        
        self._updateMarkButtonAndStatusView()
    }
    

    private func _fillView() {
        self.titleTextField.text = self.task.title
        if count(self.task.longDescription ?? "") > 0 {
            self.notesTextView.text = self.task.longDescription!
        }
    }
    
    
    /// Mark: UITableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch TableViewType(rawValue:tableView.tag)! {
        case .Locations:
            return 1
            
        case .Dates:
            return 1
            
        case .Links:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        func _createNotSetCell(title: String) -> NTHCenterLabelCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHCenterLabelCell") as! NTHCenterLabelCell
            cell.label.font = UIFont(name: "AvenirNext-Regular", size: 14.0)
            cell.label.text = title
            cell.label.textColor = UIColor.NTHSubtitleTextColor()
            cell.selectedBackgroundView = UIView()
            return cell
        }
        
        func _createTwoLabelCell(topText: String, bottomText: String) -> NTHTwoLineLeftLabelCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHTwoLineLeftLabelCell") as! NTHTwoLineLeftLabelCell
            cell.topLabel.font = UIFont(name: "AvenirNext-Regular", size: 18.0)
            cell.topLabel.text = topText
            
            cell.bottomLabel.font = UIFont(name: "AvenirNext-Regular", size: 12.0)
            cell.bottomLabel.text = bottomText
            
            cell.selectedBackgroundView = UIView()
            return cell
        }
        
        func _createRegularCell(title: String) -> NTHLeftLabelCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHLeftLabelCell") as! NTHLeftLabelCell
            cell.label.font = UIFont(name: "AvenirNext-Regular", size: 18.0)
            cell.label.text = title
            cell.selectedBackgroundView = UIView()
            return cell
        }
        
        switch TableViewType(rawValue:tableView.tag)! {
        case .Locations:
            if let reminder = self.task.locationReminderInfo {
                let topText = reminder.place.customName
                let prefix = reminder.onArrive ? "Arrive" : "Leave"
                let bottomText = prefix + ", " + reminder.distance.metersOrKilometers()
                
                return _createTwoLabelCell(topText, bottomText)
            } else {
                return _createNotSetCell("No location reminders")
            }
            
        case .Dates:
            if let reminder = self.task.dateReminderInfo {
                let topText = NSDateFormatter.NTHStringFromDate(reminder.fireDate)
                let bottomText = RepeatInterval.descriptionForInterval(interval: reminder.repeatInterval)
                return _createTwoLabelCell(topText, bottomText)
            } else {
                return _createNotSetCell("No date reminders")
            }
            
        case .Links:
            if self.task.connections.allObjects.count > 0 {
                let link = self.task.connections.allObjects[indexPath.row] as! Connection
                
                let name: String!
                if link is Contact {
                    name = (link as! Contact).name
                } else {
                    name = (link as! Place).customName
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
            break
            
        case .Dates:
            break
            
        case .Links:
            break
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch TableViewType(rawValue:tableView.tag)! {
        case .Locations:
            if let reminder = self.task.locationReminderInfo {
                return 69
            } else {
                return 50
            }
        case .Dates:
            if let reminder = self.task.dateReminderInfo {
                return 69
            } else {
                return 50
            }
            
        case .Links:
            return 50
        }
    }
    
    
    private func _oneLineCellHeight() -> CGFloat {
        return 50.0
    }
    
    private func _twoLineCellHeight() -> CGFloat {
        return 62.0
    }
    
    private func _locationRemindersTableViewHeight() -> CGFloat {
        if let reminder = self.task.locationReminderInfo {
            return self._twoLineCellHeight()
        } else {
            return self._oneLineCellHeight()
        }
    }
    
    private func _datesRemindersTableViewHeight() -> CGFloat {
        if let reminder = self.task.dateReminderInfo {
            return self._twoLineCellHeight()
        } else {
            return self._oneLineCellHeight()
        }
    }
    
    private func _linksTableViewHeight() -> CGFloat {
        return self._oneLineCellHeight() * CGFloat(max(1, self.task.connections.count))
    }
    
    private func _refreshTableView(tableView: UITableView, heightConstraint: NSLayoutConstraint, height: CGFloat) {
        /// Update table view height
        heightConstraint.constant = height
        
        UIView.animateWithDuration(NSTimeInterval(0.3), animations: {
            self.view.needsUpdateConstraints()
            tableView.reloadData()
            return /// explicit return
        })
    }
    
    /// Actions
    
    @IBAction func editPressed(sender: AnyObject) {
        
    }
    
    @IBAction func markPressed(sender: AnyObject) {
        self.task.changeState()
        self._updateMarkButtonAndStatusView()
        self.context.save(nil)
        self.context.parentContext?.save(nil)
    }
    
    private func _updateMarkButtonAndStatusView() {
        self.markButton.setTitle(self.task.state == .Done ? "Mark as Active" : "Mark as Done", forState: UIControlState.Normal)
        self.taskStatusView.state = self.task.state
    }
    
    @IBAction func deletePressed(sender: AnyObject) {
        let alert = UIAlertController(title: "Delete", message: "Do you want to delete \"\(self.task.title)\"?", preferredStyle: UIAlertControllerStyle.Alert)
        
        /// YES
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive, handler: { (action) -> Void in
            self.context.deleteObject(self.task)
            self.context.save(nil)
            self.context.parentContext?.save(nil)
            self.navigationController?.popViewControllerAnimated(true)
        }))
        
        /// NO
        alert.addAction(UIAlertAction.cancelAction("No", handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
