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
    

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
    var context: NSManagedObjectContext!
    var reminder: DateReminder!
    var completionBlock: ((reminder: DateReminder) -> Void)!
    
    
    private enum CellType: Int {
        case Date, RepeatInterval
    }

    
    private enum SegueIdentifier: String {
        case SelectRepeatInterval = "SelectRepeatInterval"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib("NTHTwoLineLeftLabelCell")
        
        /// create reminder if not exists
        if self.reminder == nil {
            self.reminder = DateReminder.create(self.context) as DateReminder
            self.reminder.fireDate = NSDate(timeIntervalSinceNow: NSTimeInterval(3600))
        }
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
        self.completionBlock(reminder: self.reminder)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.SelectRepeatInterval.rawValue {
            let vc = segue.destinationViewController as! NTHSelectRepeatIntervalViewController
            vc.repeatInterval = self.reminder.repeatInterval
            vc.completionBlock = { repeatInterval in
                self.reminder.repeatInterval = repeatInterval
                self.tableView.reloadData()
            }
        }
    }
    
    /// Mark: UITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch CellType(rawValue: indexPath.row)! {
        case .Date:
            return NTHTwoLineLeftLabelCell.create(tableView, title: "Date", subtitle: NSDateFormatter.NTHStringFromDate(self.reminder.fireDate))
            
        case .RepeatInterval:
            let interval = self.reminder.repeatInterval
            let cell = NTHTwoLineLeftLabelCell.create(tableView, title: "Repeat Interval", subtitle: RepeatInterval.descriptionForInterval(interval: interval))
            cell.accessoryType = .DisclosureIndicator
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 62
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch CellType(rawValue: indexPath.row)! {
        case .Date:
            let datePicker = NTHDateTimePickerViewController.instantiate()
            datePicker.mode = UIDatePickerMode.DateAndTime
            datePicker.setDate(self.reminder.fireDate)
            datePicker.completionBlock = { selectedDate in
                self.reminder.fireDate = selectedDate
                self.tableView.reloadData()
            }
            
            NTHSheetSegue(identifier: nil, source: self, destination: datePicker).perform()
            return
            
        case .RepeatInterval:
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.performSegueWithIdentifier(SegueIdentifier.SelectRepeatInterval.rawValue, sender: nil)
        }
    }
}
