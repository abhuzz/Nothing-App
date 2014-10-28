//
//  InboxViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 27/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit
import CoreLocation

class InboxViewController: UITableViewController {
    
    enum Identifiers: String {
        case TaskCell = "TaskCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(TaskCell.nib(), forCellReuseIdentifier: Identifiers.TaskCell.rawValue)
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    /// Mark: UITableViewDelegate & UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.debug_tasks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Identifiers.TaskCell.rawValue, forIndexPath: indexPath) as TaskCell
        cell.update(TaskCellVM(self.debug_tasks[indexPath.row]))
        return cell
    }
    
    
    private func sizeOfLabel(label: UILabel) -> CGFloat {
        let attr = [NSFontAttributeName: label.font]
        var str: NSString = label.text as NSString!
        return str.boundingRectWithSize(label.bounds.size, options: .UsesLineFragmentOrigin, attributes: attr, context: nil).size.height
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let task = self.debug_tasks[indexPath.row]
        let cell = TaskCell.nib().instantiateWithOwner(nil, options: nil).first as TaskCell
        cell.update(TaskCellVM(task))
        
        return cell.estimatedHeight
    }

    lazy var debug_tasks: [Task] = {
        let t1: Task = Task.create(CDHelper.mainContext)
        t1.title = "Do lorem ipsum"
        t1.longDescription = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever si."
        
        let drInfo: DateReminderInfo = DateReminderInfo.create(CDHelper.mainContext)
        drInfo.fireDate = NSDate()
    
        let place: Place = Place.create(CDHelper.mainContext)
        place.coordinate = CLLocationCoordinate2D(latitude: 10, longitude: 10)
        place.originalName = "U wojtka"
        place.customName = "home"
        
        let lcInfo: LocationReminderInfo = LocationReminderInfo.create(CDHelper.mainContext)
        lcInfo.place = place
        lcInfo.distance = 100.0
        
        t1.dateReminderInfo = drInfo
        t1.locationReminderInfo = lcInfo
        
        return [t1]
    }()
}

