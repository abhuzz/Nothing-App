//
//  NTHCreateEditLocationDateReminderViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 07/03/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import CoreData

class NTHCreateEditLocationDateReminderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var dateRangeTableView: UITableView!
    @IBOutlet private weak var dateRangeTableViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var placeTableView: UITableView!
    @IBOutlet private weak var placeTableViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var regionControl: NTHRegionControl!

    private enum TableViewType: Int {
        case DateRange
        case Place
    }
    
    private enum CellType: Int {
        case FromDate, ToDate, RepeatInterval
    }
    
    private enum SegueIdentifier: String {
        case EditFromDate = "EditFromDate"
        case EditToDate = "EditToDate"
        case EditRepeatInterval = "EditRepeatInterval"
    }
    
    
    var reminder: LocationDateReminder!
    var context: NSManagedObjectContext!
    var completionBlock: ((reminder: LocationDateReminder!) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateRangeTableView.registerNib("NTHTwoLineLeftLabelCell")
        self.dateRangeTableView.tag = TableViewType.DateRange.rawValue
        self.dateRangeTableView.refreshTableView(self.dateRangeTableViewHeight, height: 3.0 * self._twoLineLabelCellHeight())
        
        self.placeTableView.tag = TableViewType.Place.rawValue
        
        if self.reminder == nil {
            self.reminder = LocationDateReminder.create(self.context)
            self.reminder.fromDate = NSDate(timeIntervalSinceNow: 60 * 60)
            self.reminder.toDate = NSDate(timeIntervalSinceNow: 14 * (24 * 60 * 60))
            self.reminder.repeatInterval = NSCalendarUnit.CalendarUnitDay
            self.reminder.distance = NSNumber(integer: 100)
            self.reminder.onArrive = NSNumber(bool: true)
        }
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch SegueIdentifier(rawValue: segue.identifier!)! {
        case .EditRepeatInterval:
            let vc = segue.destinationViewController as! NTHSelectRepeatIntervalViewController
            vc.repeatInterval = self.reminder.repeatInterval
            vc.completionBlock = { repeatInterval in
                self.reminder.repeatInterval = repeatInterval
                self.dateRangeTableView.reloadData()
            }
            
        default: return
        }
    }
    
    /// Mar: UITableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        func _twoLineCell(title: String, subtitle: String) -> NTHTwoLineLeftLabelCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHTwoLineLeftLabelCell") as! NTHTwoLineLeftLabelCell
            cell.topLabel.font = UIFont.NTHNormalTextFont()
            cell.topLabel.text = title
            
            cell.bottomLabel.font = UIFont.NTHAddNewCellFont()
            cell.bottomLabel.text = subtitle
            return cell
        }
        
        
        switch TableViewType(rawValue: tableView.tag)! {
        case .DateRange:
            let cell: NTHTwoLineLeftLabelCell
            switch CellType(rawValue: indexPath.row)! {
            case .FromDate:
                cell = _twoLineCell("From Date", NSDateFormatter.NTHStringFromDate(self.reminder.fromDate))

            case .ToDate:
                cell = _twoLineCell("To Date", NSDateFormatter.NTHStringFromDate(self.reminder.toDate))

            case .RepeatInterval:
                cell = _twoLineCell("Repeat Interval", RepeatInterval.descriptionForInterval(interval: self.reminder.repeatInterval))
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            
            cell.selectedBackgroundView = UIView()
            return cell
        
        case .Place:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch TableViewType(rawValue: tableView.tag)! {
        case .DateRange:
            
            func _presentDatePicker(date: NSDate, completion: (date: NSDate) -> Void) {
                let datePicker = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NTHDateTimePickerViewController") as! NTHDateTimePickerViewController
                
                datePicker.mode = UIDatePickerMode.DateAndTime
                datePicker.completionBlock = completion
                datePicker.setDate(date)
                
                NTHSheetSegue(identifier: nil, source: self, destination: datePicker).perform()
            }
            
            
            switch CellType(rawValue: indexPath.row)! {
            case .FromDate:
                _presentDatePicker(self.reminder.fromDate, { (date) -> Void in
                    self.reminder.fromDate = date
                    self.dateRangeTableView.reloadData()
                })
            case .ToDate:
                _presentDatePicker(self.reminder.toDate, { (date) -> Void in
                    self.reminder.toDate = date
                    self.dateRangeTableView.reloadData()
                })
            case .RepeatInterval:
                self.performSegueWithIdentifier(SegueIdentifier.EditRepeatInterval.rawValue, sender: nil)
            }
            
        case .Place:
            return
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self._twoLineLabelCellHeight()
    }
    
    func _twoLineLabelCellHeight() -> CGFloat {
        return 62.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch TableViewType(rawValue: tableView.tag)! {
        case .DateRange: return 3
        case .Place: return 1
        }
    }
}
