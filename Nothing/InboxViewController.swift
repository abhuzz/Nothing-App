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
    
    private var modelCache = TaskCellVMCache()
    
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
        let task = self.debug_tasks[indexPath.row]
        var model = self.modelCache.model(task)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Identifiers.TaskCell.rawValue, forIndexPath: indexPath) as TaskCell
        if model == nil {
            model = TaskCellVM(task)
            self.modelCache.add(model!)
        }
        
        cell.update(model!)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let task = self.debug_tasks[indexPath.row]
        
        var model = self.modelCache.model(task)
        if (model == nil) {
            model = TaskCellVM(task)
            self.modelCache.add(model!)
        }
        
        let cell = TaskCell.nib().instantiateWithOwner(nil, options: nil).first as TaskCell

        cell.update(model!)
        return cell.estimatedHeight
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor.appWhite255() : UIColor.appWhite250()
    }

    
    /// DEBUG
    lazy var debug_tasks: [Task] = {
        
        /// first
        let t1: Task = Task.create(CDHelper.mainContext)
        t1.title = "Handwriting"

        t1.longDescription = "I was #sifting through my #dead-tree postal #mail and tossing #junk in the recycling bin. Nearly #everything that arrives in my #mailbox is #junk, so I was #tossing."
        
        let drInfo: DateReminderInfo = DateReminderInfo.create(CDHelper.mainContext)
        drInfo.fireDate = NSDate()
    
        let place: Place = Place.create(CDHelper.mainContext)
        place.coordinate = CLLocationCoordinate2D(latitude: 10, longitude: 10)
        place.originalName = "U wojtka"
        place.customName = "home"
        
        let info1 = ThumbnailCache.sharedInstance.write(UIImagePNGRepresentation(UIImage(named: "city2")))
        place.thumbnailKey = info1.key
        t1.connections.addObject(place)

        
        let lcInfo: LocationReminderInfo = LocationReminderInfo.create(CDHelper.mainContext)
        lcInfo.place = place
        lcInfo.distance = 100.0
        
        t1.dateReminderInfo = drInfo
        t1.locationReminderInfo = lcInfo
        
        /// second
        let t2: Task = Task.create(CDHelper.mainContext)
        t2.title = "Buy a milk"
        t2.longDescription = "#shopping"
        
        let p2: Place = Place.create(CDHelper.mainContext)
        p2.coordinate = CLLocationCoordinate2D(latitude: 10, longitude: 10)
        p2.originalName = "somewhere"
        p2.customName = "Grocery Shop"
        
        let lcInfo2: LocationReminderInfo = LocationReminderInfo.create(CDHelper.mainContext)
        lcInfo2.place = p2
        lcInfo.distance = 100.0
        
        t2.locationReminderInfo = lcInfo2
        
        let t3: Task = Task.create(CDHelper.mainContext)
        t3.title = "Call Tomasz"
        t3.longDescription = "Talk about job opportunities in #London"
        
        let contact: Contact = Contact.create(CDHelper.mainContext)
        let image = UIImage(named: "avatar")
        
        let t3place: Place = Place.create(CDHelper.mainContext)
        let t3placeImage = UIImage(named: "city")
        let (_, placeKey) = ThumbnailCache.sharedInstance.write(UIImagePNGRepresentation(t3placeImage))
        t3place.thumbnailKey = placeKey
        t3.connections.addObject(t3place)
        
        let (_, key) = ThumbnailCache.sharedInstance.write(UIImagePNGRepresentation(image))
        contact.thumbnailKey = key
        t3.connections.addObject(contact)
        
        let t4: Task = Task.create(CDHelper.mainContext)
        t4.title = "Get rid of old stuff"
        t4.longDescription = "Cannot look at this anymoaaaar!"
        
        return [t1, t2, t3, t4]
    }()
}

