//
//  NTHCreateEditLocationReminderViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 15/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import CoreData

class NTHCreateEditLocationReminderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var placeLabel: UILabel!
    @IBOutlet private weak var placeTableView: UITableView!
    @IBOutlet private weak var separator: UIView!
    @IBOutlet private weak var doneButton: UIBarButtonItem!
    @IBOutlet private weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var regionTableView: UITableView!
    
    private enum TableViewType: Int {
        case Place, Region
    }
    
    private enum SegueIdentifier: String {
        case SelectPlace = "SelectPlace"
        case EditRegion = "EditRegion"
    }
    
    var context: NSManagedObjectContext!
    var completionBlock: ((newReminder: LocationReminder) -> Void)?
    
    var reminder: LocationReminder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._configureUIColors()
        
        self.placeTableView.tag = TableViewType.Place.rawValue
        self.placeTableView.registerNib("NTHCenterLabelCell")
        self.placeTableView.registerNib("NTHLeftLabelRemoveCell")
        
        self.regionTableView.tag = TableViewType.Region.rawValue
        self.regionTableView.registerNib("NTHTwoLineLeftLabelCell")
        
        /// Check if reminder exists, if not create new one
        if self.reminder == nil {
            self.reminder = LocationReminder.create(self.context) as LocationReminder
            self.reminder.distance = 100.0
            self.reminder.onArrive = true
        }
        
        self._validateDoneButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.placeTableView.reloadData()
        self._validateDoneButton()
    }
    
    private func _configureUIColors() {
        self.placeLabel.textColor = UIColor.NTHHeaderTextColor()
        self.separator.backgroundColor = UIColor.NTHTableViewSeparatorColor()
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        self.context.save(nil) /// save temporary context and pass object from this context along
        self.completionBlock?(newReminder: reminder)
    
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func _validateDoneButton() {
        self.doneButton.enabled = self.reminder.place != nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch SegueIdentifier(rawValue: segue.identifier!)! {
        case .SelectPlace:
            let vc = segue.destinationViewController as! NTHSimpleSelectLinkViewController
            vc.context = self.context
            vc.links = ModelController().allPlaces(self.context)
            vc.selectedLink = self.reminder.place
            vc.completionBlock = { selected in
                self.reminder.place = (selected as! Place)
            }
            
        case .EditRegion:
            let vc = segue.destinationViewController as! NTHSelectRegionViewController
            vc.settings = RegionAndDistance(onArrive: self.reminder.onArrive.boolValue, distance: self.reminder.distance.floatValue)
            vc.completionBlock = { settings in
                self.reminder.onArrive = settings.onArrive
                self.reminder.distance = settings.distance
                self.regionTableView.reloadData()
                return
            }
        }
    }
    
    /// Mark: Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch TableViewType(rawValue: tableView.tag)! {
        case .Place:
            if let place = self.reminder.place {
                let cell = tableView.dequeueReusableCellWithIdentifier("NTHLeftLabelRemoveCell") as! NTHLeftLabelRemoveCell
                cell.label.text = place.name
                cell.label.font = UIFont.NTHNormalTextFont()
                cell.selectedBackgroundView = UIView()
                cell.tintColor = UIColor.NTHNavigationBarColor()
                cell.clearPressedBlock = { cell in
                    self.reminder.place = nil
                    self._validateDoneButton()
                    self.placeTableView.reloadData()
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("NTHCenterLabelCell") as! NTHCenterLabelCell
                cell.label.text = "+ Select place"
                cell.label.font = UIFont.NTHAddNewCellFont()
                cell.selectedBackgroundView = UIView()
                return cell
            }
            
        case .Region:
            func _twoLineCell(title: String, subtitle: String) -> NTHTwoLineLeftLabelCell {
                let cell = tableView.dequeueReusableCellWithIdentifier("NTHTwoLineLeftLabelCell") as! NTHTwoLineLeftLabelCell
                cell.topLabel.font = UIFont.NTHNormalTextFont()
                cell.topLabel.text = title
                
                cell.bottomLabel.font = UIFont.NTHAddNewCellFont()
                cell.bottomLabel.text = subtitle
                cell.accessoryType = .DisclosureIndicator
                cell.selectedBackgroundView = UIView()
                return cell
            }
            
            let prefix = self.reminder.onArrive.boolValue ? "Arrive" : "Leave"
            let description = prefix + ", " + self.reminder.distance.floatValue.metersOrKilometers()
            return _twoLineCell("Region and distance", description)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch TableViewType(rawValue: tableView.tag)! {
        case .Place:
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
            self.performSegueWithIdentifier(SegueIdentifier.SelectPlace.rawValue, sender: nil)
            self._validateDoneButton()

        case .Region:
            self.performSegueWithIdentifier(SegueIdentifier.EditRegion.rawValue, sender: nil)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch TableViewType(rawValue: tableView.tag)! {
        case .Place: return 50
        case .Region: return 62
        }
    }
}
