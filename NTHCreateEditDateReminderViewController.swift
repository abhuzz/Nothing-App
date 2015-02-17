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
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var repeatIntervalLabel: UILabel!
    @IBOutlet private weak var separator: UIView!
    @IBOutlet private weak var doneButton: UIBarButtonItem!

    private var repeatIntervalIndexPath: NSIndexPath?
    private var repeatIntervals = RepeatInterval.allIntervals()
    
    
    
    var context: NSManagedObjectContext!
    var completionBlock: ((newReminder: DateReminderInfo) -> Void)?
    
    
    
    private func _configureUIColors() {
        self.dateAndtimeLabel.textColor = UIColor.NTHHeaderTextColor()
        self.repeatIntervalLabel.textColor = UIColor.NTHHeaderTextColor()
        self.separator.backgroundColor = UIColor.NTHTableViewSeparatorColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._configureUIColors()
        self.datePicker.setDate(NSDate(), animated: false)
        self.datePicker.datePickerMode = UIDatePickerMode.DateAndTime
        self.tableView.registerNib("NTHLeftLabelCell")
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        let reminder: DateReminderInfo = DateReminderInfo.create(self.context)
        reminder.fireDate = self.datePicker.date
        reminder.repeatInterval = self.repeatIntervals[repeatIntervalIndexPath!.row]
        self.completionBlock?(newReminder: reminder)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    /// Mark: UITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.repeatIntervals.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NTHLeftLabelCell") as! NTHLeftLabelCell
        cell.label.text = RepeatInterval.descriptionForInterval(interval: self.repeatIntervals[indexPath.row])
        cell.label.font = UIFont.NTHNormalTextFont()
        cell.selectedBackgroundView = UIView()
        cell.tintColor = UIColor.NTHNavigationBarColor()

        if self.repeatIntervalIndexPath == nil && indexPath.row == 0 {
            cell.accessoryType = .Checkmark
            self.repeatIntervalIndexPath = indexPath
        }
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
