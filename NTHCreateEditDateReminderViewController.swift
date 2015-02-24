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

    private var repeatIntervalIndexPath: NSIndexPath?
    private var repeatIntervals = RepeatInterval.allIntervals()
    private var selectedDate: NSDate?
    
    var editedReminder: DateReminderInfo?
    var context: NSManagedObjectContext!
    var completionBlock: ((newReminder: DateReminderInfo) -> Void)?
    
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
        
        if let reminder = self.editedReminder {
            self.selectedDate = reminder.fireDate
        }
        
        self.dateTableView.registerNib("NTHCenterLabelCell")
        self.dateTableView.registerNib("NTHLeftLabelCell")
        self.dateTableView.tag = TableViewType.Date.rawValue
        
        self.tableView.registerNib("NTHLeftLabelCell")
        self.tableView.tag = TableViewType.RepeatInterval.rawValue
        
        self._validateDoneButton()
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        if self.editedReminder == nil {
            let reminder: DateReminderInfo = DateReminderInfo.create(self.context)
            reminder.fireDate = self.selectedDate!
            reminder.repeatInterval = self.repeatIntervals[self.repeatIntervalIndexPath!.row]
            self.completionBlock?(newReminder: reminder)
        } else {
            let reminder = self.editedReminder!
            reminder.fireDate = self.selectedDate!
            reminder.repeatInterval = self.repeatIntervals[self.repeatIntervalIndexPath!.row]
            self.completionBlock?(newReminder: self.editedReminder!)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func _validateDoneButton() {
        self.doneButton.enabled = (self.selectedDate != nil)
    }
    
    
    /// Mark: UITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch TableViewType(rawValue: tableView.tag)! {
        case .Date:
            return 1
        
        case .RepeatInterval:
            return self.repeatIntervals.count
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
                if let date = self.selectedDate {
                    return _leftLabelCell(NSDateFormatter.NTHStringFromDate(date))
                } else {
                    return _centerLabelCell("+ Select date")
                }
            
            case .RepeatInterval:
                let interval = self.repeatIntervals[indexPath.row]
                let cell = _leftLabelCell(RepeatInterval.descriptionForInterval(interval: interval))
                
                if (self.repeatIntervalIndexPath == nil && indexPath.row == 0 && self.editedReminder == nil) || (self.editedReminder != nil && self.editedReminder!.repeatInterval == interval)  {
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
                let datePicker = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NTHTimePickerViewController") as! NTHTimePickerViewController
                
                datePicker.mode = UIDatePickerMode.DateAndTime
                datePicker.completionBlock = { selectedDate in
                    self.selectedDate = selectedDate
                    self.dateTableView.reloadData()
                    self._validateDoneButton()
                }
                
                if let date = self.selectedDate {
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
        }
    }
}
