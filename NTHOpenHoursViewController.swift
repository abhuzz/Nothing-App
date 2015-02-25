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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib("NTHOpenHoursCell")
        self.tableView.tableFooterView = UIView()
    }
    
    /// Mark: UITableView
    
    private func weekDays() -> [String] {
        return ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NTHOpenHoursCell") as! NTHOpenHoursCell
        cell.delegate = self
        cell.enabledSwitch.setOn(true, animated: false)
        cell.selectedBackgroundView = UIView()
        cell.dayNameLabel.text = self.weekDays()[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 71
    }
    
    /// Mark: NTHOpenHoursCellDelegate
    
    func cellDidChangeSwitchValue(cell: NTHOpenHoursCell, value: Bool) {
        
    }
}
