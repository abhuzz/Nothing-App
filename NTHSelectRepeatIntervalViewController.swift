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
        self.prepareOptions()
    }
    
    private func prepareOptions() {
        let intervals = RepeatInterval.allIntervals()
        for interval in intervals {
            self.options.append(Option(desc: RepeatInterval.descriptionForInterval(interval: interval), unit: interval))
        }
    }
    
    @IBAction func closePressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NTHSelectRepeatIntervalCell") as! NTHSelectRepeatIntervalCell
        cell.label.text = self.options[indexPath.row].desc
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.completionBlock?(unit: self.options[indexPath.row].unit, description: self.options[indexPath.row].desc)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
