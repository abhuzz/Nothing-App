//
//  NTHTaskDetailsViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 05/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHTaskDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var connectionTableView: UITableView!
    @IBOutlet weak var connectionTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var titleControl: NTHBasicTitleDetailView!
    @IBOutlet weak var descriptionControl: NTHBasicTitleDetailView!
    @IBOutlet weak var locationReminderControl: NTHDoubleTitleDetailView!
    @IBOutlet weak var dateReminderControl: NTHDoubleTitleDetailView!
    
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let connectionCellNib = UINib(nibName: "NTHConnectionCell", bundle: nil)
        self.connectionTableView.registerNib(connectionCellNib, forCellReuseIdentifier: "NTHConnectionCell")

        self.connectionTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshConnectionsTableView()
    }
    
    /// Mark: UITableViewDelegate & UITableViewDataSource
    func numberOfItemsInConnectionTableView() -> Int {
        return self.task.allConnections.count
    }
    
    func heightOfConnectionTableViewCell() -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfItemsInConnectionTableView()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NTHConnectionCell") as NTHConnectionCell
        let connection: Connection = self.task.allConnections.allObjects[indexPath.row] as Connection
        if connection is Contact {
            cell.label.text = (connection as Contact).name
        } else {
            cell.label.text = (connection as Place).customName
        }
        
        cell.hideShowButton(true, animated: false)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.heightOfConnectionTableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    private func refreshConnectionsTableView() {
        /// Update table view height
        let height = CGFloat(self.numberOfItemsInConnectionTableView()) * self.heightOfConnectionTableViewCell()
        self.connectionTableViewHeight.constant = height
        
        UIView.animateWithDuration(NSTimeInterval(0.3), animations: {
            self.view.needsUpdateConstraints()
            self.connectionTableView.reloadData()
            return /// explicit return
        })
    }

}
