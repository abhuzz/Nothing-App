//
//  NTHSelectRepeatIntervalViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 04/03/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHSelectRepeatIntervalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet private weak var tableView: UITableView!
    
    private var repeatIntervals = RepeatInterval.allIntervals()
    private var repeatIntervalIndexPath: NSIndexPath?
    
    var repeatInterval: NSCalendarUnit!
    var completionBlock: ((repeatInterval: NSCalendarUnit!) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib("NTHLeftLabelCell")
    }
    
    /// Mark: UITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repeatIntervals.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        func _leftLabelCell(title: String) -> NTHLeftLabelCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHLeftLabelCell") as! NTHLeftLabelCell
            cell.label.text = title
            cell.label.font = UIFont.NTHNormalTextFont()
            cell.leadingConstraint.constant = 15.0
            cell.selectedBackgroundView = UIView()
            cell.tintColor = UIColor.NTHNavigationBarColor()
            return cell
        }

        let interval = self.repeatIntervals[indexPath.row]
        let cell = _leftLabelCell(RepeatInterval.descriptionForInterval(interval: interval))
        
        if self.repeatInterval == interval {
            cell.accessoryType = .Checkmark
            self.repeatIntervalIndexPath = indexPath
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let previousIndexPath = self.repeatIntervalIndexPath {
            tableView.cellForRowAtIndexPath(previousIndexPath)?.accessoryType = .None
            self.repeatIntervalIndexPath = nil
        }
        
        let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        if cell.accessoryType == .None {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        self.repeatIntervalIndexPath = indexPath
        self.repeatInterval = self.repeatIntervals[indexPath.row]
        self.completionBlock?(repeatInterval: self.repeatInterval)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.4 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.navigationController?.popViewControllerAnimated(true)
        }

    }
}
