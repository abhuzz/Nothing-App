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
    @IBOutlet weak var doneButton: UIBarButtonItem!

    private enum TableViewType: Int {
        case DateRange, Place
    }
    
    private enum CellDateType: Int {
        case FromDate, ToDate, RepeatInterval
    }
    
    private enum CellPlaceType: Int {
        case Place, Region
    }
    
    private enum SegueIdentifier: String {
        case EditFromDate = "EditFromDate"
        case EditToDate = "EditToDate"
        case EditRepeatInterval = "EditRepeatInterval"
        case EditRegion = "EditRegion"
        case SelectPlace = "SelectPlace"
    }
    
    
    var reminder: LocationDateReminder!
    var context: NSManagedObjectContext!
    var completionBlock: ((reminder: LocationDateReminder!) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateRangeTableView.tag = TableViewType.DateRange.rawValue
        self.dateRangeTableView.registerNib("NTHTwoLineLeftLabelCell")
        self.dateRangeTableView.refreshTableView(self.dateRangeTableViewHeight, height: 3.0 * self._twoLineLabelCellHeight())
        
        self.placeTableView.tag = TableViewType.Place.rawValue
        self.placeTableView.registerNib("NTHTwoLineLeftLabelCell")
        
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
        self.context.save(nil)
        self.completionBlock?(reminder:self.reminder)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func _validateDoneButton() {
        self.doneButton.enabled = (self.reminder.place != nil)
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
            
        case .EditRegion:
            break
//            let vc = segue.destinationViewController as! NTHSelectRegionViewController
//            vc.reminder = self.reminder
            
//        case .SelectPlace:
//            let vc = segue.destinationViewController as! NTHSimpleSelectLinkViewController
//            vc.linkType = LinkType.Place
//            vc.links = ModelController().allPlaces(self.context)
//            
//            vc.selectedLink = self.reminder.place
//            vc.completionBlock = { selected in
//                self.reminder.place = (selected as! Place)
//                self.placeTableView.reloadData()
//                self._validateDoneButton()
//            }
            
        default: return
        }
    }
    
    
    /// Mar: UITableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch TableViewType(rawValue: tableView.tag)! {
        case .DateRange:
            let cell: NTHTwoLineLeftLabelCell
            switch CellDateType(rawValue: indexPath.row)! {
            case .FromDate:
                cell = NTHTwoLineLeftLabelCell.create(tableView, title: "From Date", subtitle: NSDateFormatter.NTHStringFromDate(self.reminder.fromDate))
            
            case .ToDate:
                cell = NTHTwoLineLeftLabelCell.create(tableView, title: "To Date", subtitle: NSDateFormatter.NTHStringFromDate(self.reminder.toDate))

            case .RepeatInterval:
                cell = NTHTwoLineLeftLabelCell.create(tableView, title: "Repeat Interval", subtitle: RepeatInterval.descriptionForInterval(interval: self.reminder.repeatInterval))
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            
            return cell
        
        case .Place:
            switch CellPlaceType(rawValue: indexPath.row)! {
            case .Place:
                let cell = NTHTwoLineLeftLabelCell.create(tableView, title: "Place", subtitle: "Select")
                if let place = self.reminder.place {
                    cell.bottomLabel.text = place.name
                }
                cell.accessoryType = .DisclosureIndicator
                return cell
                
            case .Region:
                let prefix = self.reminder.onArrive.boolValue ? "Arrive" : "Leave"
                let description = prefix + ", " + self.reminder.distance.floatValue.metersOrKilometers()
                let cell = NTHTwoLineLeftLabelCell.create(tableView, title: "Region and distance", subtitle: description)
                cell.accessoryType = .DisclosureIndicator
                return cell
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch TableViewType(rawValue: tableView.tag)! {
        case .DateRange:
            func _presentDatePicker(date: NSDate, completion: (date: NSDate) -> Void) {
                let datePicker = NTHDateTimePickerViewController.instantiate()
                datePicker.mode = UIDatePickerMode.DateAndTime
                datePicker.completionBlock = completion
                datePicker.setDate(date)
                
                NTHSheetSegue(identifier: nil, source: self, destination: datePicker).perform()
            }
            
            
            switch CellDateType(rawValue: indexPath.row)! {
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
            switch CellPlaceType(rawValue: indexPath.row)! {
            case .Place:
                self.performSegueWithIdentifier(SegueIdentifier.SelectPlace.rawValue, sender: nil)

            case .Region:
                self.performSegueWithIdentifier(SegueIdentifier.EditRegion.rawValue, sender: nil)
            }
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
        case .Place: return 2
        }
    }
}
