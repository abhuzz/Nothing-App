//
//  NTHTrashViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 23/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import CoreData

class NTHTemplateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NTHCoreDataCloudSyncProtocol, NTHTemplateCellDelegate {

    @IBOutlet private weak var tableView: UITableView!
    
    private var resultsController: NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._createResultsController()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.registerNib("NTHTemplateCell")
        self.tableView.registerNib("NTHCenterLabelCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NTHCoreDataCloudSync.sharedInstance.addObserver(self)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NTHCoreDataCloudSync.sharedInstance.removeObserver(self)
    }
    
    private func _createResultsController() {
        let request = NSFetchRequest(entityName: "Task")
        request.predicate = NSPredicate(format: "trashed == 0 AND isTemplate == 1", argumentArray: nil)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        self.resultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CDHelper.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        self.resultsController.performFetch(nil)
    }
    
    /// Mark: UITableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if let objects = self.resultsController.fetchedObjects {
            count = objects.count
        }
        
        return max(1, count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.resultsController.fetchedObjects?.count == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHCenterLabelCell") as! NTHCenterLabelCell
            cell.label.text = "No templates"
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
            cell.label.textColor = UIColor.blackColor()
            cell.label.font = UIFont.NTHAddNewCellFont()
            return cell
        } else {
            let template = (self.resultsController.fetchedObjects as! [Task])[indexPath.row]
            
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHTemplateCell") as! NTHTemplateCell
            cell.update(self.resultsController.fetchedObjects![indexPath.row] as! Task)
            cell.delegate = self
            cell.selectedBackgroundView = UIView()
            return cell
        }
    }
    
    func cellDidPressUse(cell: NTHInboxCell) {
        let indexPath = self.tableView.indexPathForCell(cell)!
        let template = self.resultsController.fetchedObjects![indexPath.row] as! Task
        
        self.createTaskFromTemplate(template)

        self.resultsController.performFetch(nil)
        self.tableView.reloadData()
    }
    
    
    func createTaskFromTemplate(template: Task) {
        let task: Task = Task.create(CDHelper.mainContext)
        task.createdAt = NSDate()
        task.links = template.links
        task.longDescription = template.longDescription
        task.uniqueIdentifier = NSUUID().UUIDString
        task.title = template.title
        
        var copiedReminders = Set<Reminder>()
        for reminder in template.reminders {
            if reminder is DateReminder {
                let reminder = reminder as! DateReminder
                var r: DateReminder = DateReminder.create(CDHelper.mainContext)
                r.fireDate = reminder.fireDate
                r.repeatInterval = reminder.repeatInterval
                task.addReminder(r)
            } else if reminder is LocationReminder {
                let reminder = reminder as! LocationReminder
                var r: LocationReminder = LocationReminder.create(CDHelper.mainContext)
                r.distance = reminder.distance
                r.onArrive = reminder.onArrive
                r.place = reminder.place
                r.useOpenHours = reminder.useOpenHours
                task.addReminder(r)
            }
        }
        
        task.isTemplate = false
        
        CDHelper.mainContext.save(nil)
        
        let alert = UIAlertController.alert("Success", message: "Task created.")
        alert.addAction(UIAlertAction.cancelAction("OK", handler: { (action) -> Void in
            /// Do nothing
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.resultsController.fetchedObjects?.count == 0 {
            return 60
        } else {
            return 72
        }
    }
    
    
    /// Mark: Template Cell

    func cellDidPressDelete(cell: NTHInboxCell) {
        let indexPath = self.tableView.indexPathForCell(cell)!
        CDHelper.mainContext.deleteObject(self.resultsController.fetchedObjects![indexPath.row] as! NSManagedObject)
        CDHelper.mainContext.save(nil)
        
        self.resultsController.performFetch(nil)
        self.tableView.reloadData()
    }
    
    /// MARK: NTHCoreDataCloudSyncProtocol
    func persistentStoreDidReceiveChanges() {
        self.resultsController.performFetch(nil)
        self.tableView.reloadData()
    }
}
