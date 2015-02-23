//
//  NTHTrashViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 23/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import CoreData

class NTHTrashViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NTHTrashCellDelegate {

    @IBOutlet private weak var tableView: UITableView!
    
    private var resultsController: NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._createResultsController()
        
        self.tableView.registerNib("NTHTrashCell")
    }
    
    private func _createResultsController() {
        let request = NSFetchRequest(entityName: "Task")
        request.predicate = NSPredicate(format: "trashed == 1", argumentArray: nil)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        self.resultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CDHelper.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        self.resultsController.performFetch(nil)
    }
    
    @IBAction func eraseAllPressed(sender: AnyObject) {
        if let tasks = self.resultsController.fetchedObjects as? [Task] {
            for task in tasks {
                CDHelper.mainContext.deleteObject(task)
            }
            
            CDHelper.mainContext.save(nil)
            self.resultsController.performFetch(nil)
            self.tableView.reloadData()
        }
    }
    
    /// Mark: UITableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NTHTrashCell") as! NTHTrashCell
        cell.update(self.resultsController.fetchedObjects![indexPath.row] as! Task)
        cell.delegate = self
        cell.selectedBackgroundView = UIView()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 72
    }
    
    
    /// Mark: Trash Cell

    func cellDidPressDelete(cell: NTHInboxCell) {
        let indexPath = self.tableView.indexPathForCell(cell)!
        CDHelper.mainContext.deleteObject(self.resultsController.fetchedObjects![indexPath.row] as! NSManagedObject)
        CDHelper.mainContext.save(nil)
        
        self.resultsController.performFetch(nil)
        self.tableView.reloadData()
    }
    
    func cellDidPressRestore(cell: NTHInboxCell) {
        let indexPath = self.tableView.indexPathForCell(cell)!
        let task = self.resultsController.fetchedObjects![indexPath.row] as! Task
        task.trashed = false.toNSNumber()
        CDHelper.mainContext.save(nil)
        
        self.resultsController.performFetch(nil)
        self.tableView.reloadData()
    }
}
