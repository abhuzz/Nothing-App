//
//  NTHCreateEditDateReminderViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 28/01/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import CoreData

class NTHCreateEditDateReminderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private weak var dateAndtimeLabel: UILabel!
    @IBOutlet weak var dateTableView: UITableView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var repeatIntervalLabel: UILabel!
    @IBOutlet private weak var separator: UIView!
    @IBOutlet private weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    private var repeatIntervalIndexPath: NSIndexPath?
    private var repeatIntervals = RepeatInterval.allIntervals()
    
    var context: NSManagedObjectContext!
    var reminder: DateReminder!
    var completionBlock: ((newReminder: DateReminder) -> Void)?
    
    private enum TableViewType: Int {
        case Date = 0
        case RepeatInterval
    }
    
    private func _configureUIColors() {
        self.dateAndtimeLabel.textColor = UIColor.NTHHeaderTextColor()
        self.repeatIntervalLabel.textColor = UIColor.NTHHeaderTextColor()
        self.separator.backgroundColor = UIColor.NTHTableViewSeparatorColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._configureUIColors()
        
        self.dateTableView.registerNib("NTHCenterLabelCell")
        self.dateTableView.registerNib("NTHLeftLabelCell")
        self.dateTableView.tag = TableViewType.Date.rawValue
        
        self.tableView.registerNib("NTHLeftLabelCell")
        self.tableView.tag = TableViewType.RepeatInterval.rawValue
        
        /// create reminder if not exists
        if self.reminder == nil {
            self.reminder = DateReminder.create(self.context) as DateReminder
            self.reminder.fireDate = NSDate(timeIntervalSinceNow: NSTimeInterval(3600))
        }
        
        println("date = \(self.reminder.fireDate)")
        self._validateDoneButton()
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        self.context.save(nil)
        self.completionBlock?(newReminder: self.reminder)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func _validateDoneButton() {
        self.doneButton.enabled = (self.reminder.fireDate != nil)
    }
    
    
    /// Mark: UITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch TableViewType(rawValue: tableView.tag)! {
        case .Date: return 1
        case .RepeatInterval: return self.repeatIntervals.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        func _leftLabelCell(title: String) -> NTHLeftLabelCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHLeftLabelCell") as! NTHLeftLabelCell
            cell.label.text = title
            cell.label.font = UIFont.NTHNormalTextFont()
            cell.selectedBackgroundView = UIView()
            cell.tintColor = UIColor.NTHNavigationBarColor()
            return cell
        }
        
        func _centerLabelCell(title: String) -> NTHCenterLabelCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHCenterLabelCell") as! NTHCenterLabelCell
            cell.label.text = title
            cell.label.font = UIFont.NTHAddNewCellFont()
            cell.selectedBackgroundView = UIView()
            cell.tintColor = UIColor.NTHNavigationBarColor()
            return cell
        }
        
        switch TableViewType(rawValue: tableView.tag)! {
        case .Date:
            if let date = self.reminder.fireDate {
                return _leftLabelCell(NSDateFormatter.NTHStringFromDate(date))
            } else {
                return _centerLabelCell("+ Select date")
            }
            
        case .RepeatInterval:
            let interval = self.repeatIntervals[indexPath.row]
            let cell = _leftLabelCell(RepeatInterval.descriptionForInterval(interval: interval))
            
            if (self.repeatIntervalIndexPath == nil && indexPath.row == 0 && self.reminder.fireDate == nil) ||
                (self.reminder.repeatInterval == interval)  {
                    cell.accessoryType = .Checkmark
                    self.repeatIntervalIndexPath = indexPath
            }
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch TableViewType(rawValue: tableView.tag)! {
        case .Date:
            let datePicker = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NTHDateTimePickerViewController") as! NTHDateTimePickerViewController
            
            datePicker.mode = UIDatePickerMode.DateAndTime
            datePicker.completionBlock = { selectedDate in
                self.reminder.fireDate = selectedDate
                self.dateTableView.reloadData()
                self._validateDoneButton()
            }
            
            if let date = self.reminder.fireDate {
                datePicker.setDate(date)
            }
            
            NTHSheetSegue(identifier: nil, source: self, destination: datePicker).perform()
            return
            
        case .RepeatInterval:
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            if let previousIndexPath = self.repeatIntervalIndexPath {
                tableView.cellForRowAtIndexPath(previousIndexPath)?.accessoryType = .None
                self.repeatIntervalIndexPath = nil
            }
            
            let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
            if cell.accessoryType == .None {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
            
            self.repeatIntervalIndexPath = indexPath
            self.reminder.repeatInterval = self.repeatIntervals[indexPath.row]
        }
    }
}
