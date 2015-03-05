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
    @IBOutlet private weak var separator: UIView!
    @IBOutlet private weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
    
    var context: NSManagedObjectContext!
    var reminder: DateReminder!
    var completionBlock: ((newReminder: DateReminder) -> Void)?
    
    
    
    private enum TableViewType: Int {
        case Date = 0
        case Options
    }
    
    
    
    private enum SegueIdentifier: String {
        case SelectRepeatInterval = "SelectRepeatInterval"
    }
    
    private func _configureUIColors() {
        self.dateAndtimeLabel.textColor = UIColor.NTHHeaderTextColor()
        self.separator.backgroundColor = UIColor.NTHTableViewSeparatorColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._configureUIColors()
        
        self.dateTableView.registerNib("NTHCenterLabelCell")
        self.dateTableView.registerNib("NTHLeftLabelCell")
        self.dateTableView.tag = TableViewType.Date.rawValue
        
        self.tableView.registerNib("NTHTwoLineLeftLabelCell")
        self.tableView.tag = TableViewType.Options.rawValue
        
        /// create reminder if not exists
        if self.reminder == nil {
            self.reminder = DateReminder.create(self.context) as DateReminder
            self.reminder.fireDate = NSDate(timeIntervalSinceNow: NSTimeInterval(3600))
        }
        
        println("date = \(self.reminder.fireDate)")
        self._validateDoneButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.SelectRepeatInterval.rawValue {
            let vc = segue.destinationViewController as! NTHSelectRepeatIntervalViewController
            vc.reminder = self.reminder
            vc.completionBlock = {
                self.tableView.reloadData()
            }
        }
    }
    
    /// Mark: UITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch TableViewType(rawValue: tableView.tag)! {
        case .Date: return 1
        case .Options: return 1
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
        
        func _twoLineLabelCell(title: String, subtitle: String) -> NTHTwoLineLeftLabelCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHTwoLineLeftLabelCell") as! NTHTwoLineLeftLabelCell
            cell.topLabel.text = title
            cell.bottomLabel.text = subtitle
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
            
        case .Options:
            let interval = self.reminder.repeatInterval
            let cell = _twoLineLabelCell("Repeat Interval", RepeatInterval.descriptionForInterval(interval: interval))
            cell.accessoryType = .DisclosureIndicator
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == self.tableView {
            return 62
        } else {
            return 50
        }
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
            
        case .Options:
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.performSegueWithIdentifier("SelectRepeatInterval", sender: nil)
        }
    }
}
