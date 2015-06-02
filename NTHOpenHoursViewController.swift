//
//  NTHOpenHoursViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 25/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHOpenHoursViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NTHOpenHoursCellDelegate {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var openHoursSwitch: UISwitch!

    var place: Place!
    var completionBlock: ((openHours: [OpenTimeRange]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.openHoursSwitch.setOn(self.place.useOpenHours.boolValue, animated: false)
        
        self.tableView.registerNib("NTHOpenHoursCell")
        self.tableView.tableFooterView = UIView()
        self._updateTableView()
    }
    
    @IBAction func openSwitchValueChanged(sender: UISwitch) {
        self.place.useOpenHours = sender.on
        self._updateTableView()
    }
    
    private func _updateTableView() {
        self.tableView.alpha = self.openHoursSwitch.on ? 1 : 0.3
        self.tableView.userInteractionEnabled = self.openHoursSwitch.on
        self.tableView.reloadData()
    }
    
    
    
    /// Mark: UITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let openHour = self._sortedOpenHours()[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("NTHOpenHoursCell") as! NTHOpenHoursCell
        cell.delegate = self
        cell.selectedBackgroundView = UIView()
        
        cell.dayNameLabel.text = openHour.dayString.uppercaseString
        
        let openHourString = NTHTime(interval: openHour.openTimeInterval).toString()
        let closeHourString = NTHTime(interval: openHour.closeTimeInterval).toString()
        cell.hourLabel.text =  openHourString + " - " + closeHourString
        cell.closedLabel.text = "Closed"
        cell.update(openHour.closed)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func _sortedOpenHours() -> [OpenTimeRange] {
        return sorted(self.place.openHours.array as! [OpenTimeRange]) { range1, range2 in
            if range1.day == .Sunday {
                return false
            } else if range2.day == .Sunday {
                return true
            }
            
            return range1.day.rawValue < range2.day.rawValue
        }
    }
    
    
    /// Mark: NTHOpenHoursCellDelegate
    func cellDidTapClock(cell: NTHOpenHoursCell) {
        let picker = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NTHOpenHoursPickerViewController") as! NTHOpenHoursPickerViewController
        
        let indexPath = self.tableView.indexPathForCell(cell)!
        let openHour = self._sortedOpenHours()[indexPath.row]
        
        picker.openHourTimeInterval = openHour.openTimeInterval
        picker.closeHourTimeInterval = openHour.closeTimeInterval
        
        picker.completionBlock = { openHourTimeInterval, closeHourTimeInterval, eachDay in
            if (eachDay) {
                for hour in self._sortedOpenHours() {
                    hour.openTimeInterval = openHourTimeInterval
                    hour.closeTimeInterval = closeHourTimeInterval
                }
            } else {
                let hour = self._sortedOpenHours()[indexPath.row]
                hour.openTimeInterval = openHourTimeInterval
                hour.closeTimeInterval = closeHourTimeInterval
            }
            self.tableView.reloadData()
        }
        
        NTHSheetSegue(identifier: nil, source: self, destination: picker).perform()
    }
    
    func cellDidTapClose(cell: NTHOpenHoursCell, closed: Bool) {
        let indexPath = self.tableView.indexPathForCell(cell)!
        self._sortedOpenHours()[indexPath.row].closed = closed
    }
}
