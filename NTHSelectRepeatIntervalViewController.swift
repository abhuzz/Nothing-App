//
//  NTHSelectRepeatIntervalViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 31/01/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHSelectRepeatIntervalViewController: UITableViewController {

    typealias NTHSelectRepeatIntervalViewControllerBlock = (unit: NSCalendarUnit, description: String) -> Void
    
    var completionBlock: NTHSelectRepeatIntervalViewControllerBlock?
    
    struct Option {
        var desc: String
        var unit: NSCalendarUnit
    }
    
    private var options = [Option]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.options.append(Option(desc: NSLocalizedString("None", comment: ""), unit: NSCalendarUnit.allZeros))
        self.options.append(Option(desc: NSLocalizedString("Once a day", comment: ""), unit: NSCalendarUnit.CalendarUnitDay))
        self.options.append(Option(desc: NSLocalizedString("Once a week", comment: ""), unit: NSCalendarUnit.CalendarUnitWeekOfYear))
        self.options.append(Option(desc: NSLocalizedString("Once a month", comment: ""), unit: NSCalendarUnit.CalendarUnitMonth))
        self.options.append(Option(desc: NSLocalizedString("Once a year", comment: ""), unit: NSCalendarUnit.CalendarUnitYear))
    }
    
    @IBAction func closePressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NTHSelectRepeatIntervalCell") as NTHSelectRepeatIntervalCell
        cell.label.text = self.options[indexPath.row].desc
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.completionBlock?(unit: self.options[indexPath.row].unit, description: self.options[indexPath.row].desc)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
