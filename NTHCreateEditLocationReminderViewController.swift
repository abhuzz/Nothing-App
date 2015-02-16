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
    @IBOutlet private weak var placesTableView: UITableView!
    @IBOutlet private weak var separator: UIView!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var regionControl: NTHRegionControl!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    private var places = [Place]()
    private var selectedIndexPath: NSIndexPath?
    
    private enum SegueIdentifier: String {
        case AddNewPlace = "AddNewPlace"
    }
    
    var context: NSManagedObjectContext!
    var completionBlock: ((newReminder: LocationReminderInfo) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._configureUIColors()
        
        self.placesTableView.registerNib("NTHCenterLabelCell")
        self.placesTableView.registerNib("NTHLeftLabelCell")
        self.places = ModelController().allPlaces(self.context)
        
        self.regionControl.configure(100.0, onArrive: true)
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
        let reminder: LocationReminderInfo = LocationReminderInfo.create(self.context)
        reminder.place = self.places[self.selectedIndexPath!.row]
        reminder.distance = self.regionControl.regionSlider.value
        reminder.onArrive = (self.regionControl.regionSegmentedControl.selectedSegmentIndex == 0)
        self.completionBlock?(newReminder: reminder)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func _validateDoneButton() {
        self.doneButton.enabled = self.selectedIndexPath != nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.AddNewPlace.rawValue {
            let vc = segue.destinationViewController as! NTHCreateNewPlaceViewController
            vc.context = self.context
            vc.completionBlock = {
                self.places = ModelController().allPlaces(self.context)
                self.placesTableView.reloadData()
            }
        }
    }
    
    /// Mark: Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == self.places.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHCenterLabelCell") as! NTHCenterLabelCell
            cell.label.text = "+ Add new place"
            cell.label.font = UIFont.NTHAddNewCellFont()
            cell.selectedBackgroundView = UIView()
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHLeftLabelCell") as! NTHLeftLabelCell
            cell.label.text = self.places[indexPath.row].customName
            cell.label.font = UIFont.NTHNormalTextFont()
            cell.selectedBackgroundView = UIView()
            cell.tintColor = UIColor.NTHNavigationBarColor()
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if indexPath.row == self.places.count {
            /// show place wizard
            self.performSegueWithIdentifier(SegueIdentifier.AddNewPlace.rawValue, sender: nil)
        } else {
            /// deselect old cell
            if let previousIndexPath = self.selectedIndexPath {
                let previousCell = tableView.cellForRowAtIndexPath(previousIndexPath) as! NTHLeftLabelCell
                previousCell.accessoryType = .None
            }
            
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! NTHLeftLabelCell
            if cell.accessoryType == .None {
                cell.accessoryType = .Checkmark
                self.selectedIndexPath = indexPath
            } else {
                cell.accessoryType = .None
            }
        }
        
        self._validateDoneButton()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }

}
