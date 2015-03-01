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
    @IBOutlet private weak var regionLabel: UILabel!
    @IBOutlet private weak var regionControl: NTHRegionControl!
    @IBOutlet private weak var doneButton: UIBarButtonItem!
    @IBOutlet private weak var cancelButton: UIBarButtonItem!
    
    private enum SegueIdentifier: String {
        case SelectPlace = "SelectPlace"
    }
    
    var context: NSManagedObjectContext!
    var completionBlock: ((newReminder: LocationReminderInfo) -> Void)?
    
    var reminder: LocationReminderInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._configureUIColors()
        
        self.placeTableView.registerNib("NTHCenterLabelCell")
        self.placeTableView.registerNib("NTHLeftLabelRemoveCell")
        
        /// Check if reminder exists, if not create new one
        if self.reminder == nil {
            self.reminder = LocationReminderInfo.create(self.context) as LocationReminderInfo
            self.reminder.distance = 100.0
            self.reminder.onArrive = true
        }
        
        self.regionControl.configure(self.reminder.distance, onArrive: self.reminder.onArrive)
        self._validateDoneButton()
        
        self.regionControl.prepareBeforePresenting()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.placeTableView.reloadData()
        self._validateDoneButton()
    }
    
    private func _configureUIColors() {
        self.placeLabel.textColor = UIColor.NTHHeaderTextColor()
        self.regionLabel.textColor = UIColor.NTHHeaderTextColor()
        self.separator.backgroundColor = UIColor.NTHTableViewSeparatorColor()
        
        self.regionControl.regionSlider.minimumTrackTintColor = UIColor.NTHNavigationBarColor()
        self.regionControl.minRegionLabel.textColor = UIColor.NTHHeaderTextColor()
        self.regionControl.curRegionLabel.textColor = UIColor.NTHHeaderTextColor()
        self.regionControl.maxRegionLabel.textColor = UIColor.NTHHeaderTextColor()
        self.regionControl.regionSegmentedControl.tintColor = UIColor.NTHNavigationBarColor()
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        self.reminder.onArrive = (self.regionControl.regionSegmentedControl.selectedSegmentIndex == 0)
        self.reminder.distance = self.regionControl.regionSlider.value
        
        self.context.save(nil) /// save temporary context and pass object from this context along
        self.completionBlock?(newReminder: reminder)
    
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func _validateDoneButton() {
        self.doneButton.enabled = self.reminder.place != nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.SelectPlace.rawValue {
            let vc = segue.destinationViewController as! NTHSimpleSelectLinkViewController
            vc.context = self.context
            vc.links = ModelController().allPlaces(self.context)
            vc.selectedLink = self.reminder.place
            vc.completionBlock = { selected in
                self.reminder.place = (selected as! Place)
            }
        }
    }
    
    /// Mark: Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        self.performSegueWithIdentifier(SegueIdentifier.SelectPlace.rawValue, sender: nil)
        self._validateDoneButton()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }

}
