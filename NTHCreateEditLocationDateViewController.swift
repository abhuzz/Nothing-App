//
//  NTHCreateEditLocationDateViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 07/03/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHCreateEditLocationDateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var dateRangeTableView: UITableView!
    @IBOutlet weak var dateRangeTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var placeTableView: UITableView!
    @IBOutlet weak var placeTableViewHeight: NSLayoutConstraint!

    private enum TableViewType: Int {
        case DateRange
        case Place
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateRangeTableView.tag = TableViewType.DateRange.rawValue
        self.placeTableView.tag = TableViewType.Place.rawValue
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        
    }
    
    /// Mar: UITableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
