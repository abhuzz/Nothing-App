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
    
    private var place: Place?
    
    private enum SegueIdentifier: String {
        case SelectPlace = "SelectPlace"
        case EditPlace = "EditPlace"
    }
    
    var context: NSManagedObjectContext!
    var completionBlock: ((newReminder: LocationReminderInfo) -> Void)?
    
    var editedReminder: LocationReminderInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._configureUIColors()
        
        self.placeTableView.registerNib("NTHCenterLabelCell")
        self.placeTableView.registerNib("NTHLeftLabelRemoveCell")
        
        if let reminder = self.editedReminder {
            self.place = reminder.place
            self.regionControl.configure(reminder.distance, onArrive: reminder.onArrive)
            self._validateDoneButton()
        } else {
            self.regionControl.configure(100.0, onArrive: true)
        }
        self.regionControl.prepareBeforePresenting()
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
    
    @IBAction func donePressed(sender: AnyObject) {
        
        let place = self.place as Place!
        let distance = self.regionControl.regionSlider.value
        let onArrive = (self.regionControl.regionSegmentedControl.selectedSegmentIndex == 0)
        
        if let reminder = self.editedReminder {
            reminder.place = place
            reminder.distance = distance
            reminder.onArrive = onArrive
            self.completionBlock?(newReminder: reminder)
        } else {
            let reminder: LocationReminderInfo = LocationReminderInfo.create(self.context)
            reminder.place = place
            reminder.distance = distance
            reminder.onArrive = onArrive
            self.completionBlock?(newReminder: reminder)
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func _validateDoneButton() {
        self.doneButton.enabled = self.place != nil || self.editedReminder != nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.SelectPlace.rawValue {
            let vc = segue.destinationViewController as! NTHSelectPlaceViewController
            vc.context = self.context
            vc.completionBlock = { selectedPlace in
                self.place = selectedPlace
                self.placeTableView.reloadData()
                self._validateDoneButton()
            }
        } else if segue.identifier == SegueIdentifier.EditPlace.rawValue {
            let vc = segue.destinationViewController as! NTHCreateEditPlaceViewController
            vc.context = self.context
            vc.editedPlace = sender as! Place!
            vc.completionBlock = {
                self.placeTableView.reloadData()
                self._validateDoneButton()
            }
        }
    }
    
    /// Mark: Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let place = self.place {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHLeftLabelRemoveCell") as! NTHLeftLabelRemoveCell
            cell.label.text = place.name
            cell.label.font = UIFont.NTHNormalTextFont()
            cell.selectedBackgroundView = UIView()
            cell.tintColor = UIColor.NTHNavigationBarColor()
            cell.clearPressedBlock = { cell in
                self.place = nil
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
        
        if let place = self.place {
            self.performSegueWithIdentifier(SegueIdentifier.EditPlace.rawValue, sender: place)
        } else {
            self.performSegueWithIdentifier(SegueIdentifier.SelectPlace.rawValue, sender: nil)
        }
        
        self._validateDoneButton()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }

}
