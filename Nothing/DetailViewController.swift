//
//  DetailViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 16/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: NTHTableViewController {
    var task: Task!
    var delegate: DetailViewControllerDelegate?
    private var model: DetailModelView?
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var navigationBarHeight: NSLayoutConstraint!
    @IBOutlet weak var changeStateButton: UIButton!
    
    private enum CellIdentifier: String {
        case TextViewCell = "TextViewCell"
        case MapCell = "MapCell"
        case SeparatorCell = "SeparatorCell"
    }
    
    /// cells
    lazy private var titleCell: TextViewCell = {
        return self.createTitleCell()
    }()
    
    lazy private var longDescriptionCell: TextViewCell = {
        return self.createLongDescriptionCell()
    }()
    
    lazy private var locationReminderDescriptionCell: TextViewCell = {
        return self.createLocationReminderDescriptionCell()
    }()
    
    lazy private var locationCell: MapCell = {
        return self.createLocationCell()
    }()
    
    lazy private var dateReminderDescriptionCell: TextViewCell = {
        return self.createDateReminderDescriptionCell()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBarHeight.constant = 64.0;
        self.tableView.contentInset = UIEdgeInsets(top: self.navigationBarHeight.constant, left: 0, bottom: 0, right: 0)
        self.update()
    }
    
    func update() {
        let model = DetailModelView(self.task)
        self.titleCell.textView.text = model.title
        
        if model.isDescription {
            self.longDescriptionCell.textView.textColor = UIColor.appBlack()
            self.longDescriptionCell.textView.text = model.longDescription
        } else {
            self.longDescriptionCell.textView.text = model.noLongDescription
            self.longDescriptionCell.textView.textColor = UIColor.appWhite186()
        }
        
        if !model.isLocationReminder {
            self.locationReminderDescriptionCell.textView.text = model.noLocationReminderDescription
            self.locationReminderDescriptionCell.textView.textColor = UIColor.appWhite186()
        } else {
            self.locationCell.coordinate = self.task.locationReminder?.place.coordinate
            self.locationReminderDescriptionCell.textView.text = model.locationReminderDescription
            self.locationReminderDescriptionCell.textView.textColor = UIColor.appBlack()
        }
        
        if !model.isDateReminder {
            self.dateReminderDescriptionCell.textView.text = model.noDateReminderDescription
            self.dateReminderDescriptionCell.textView.textColor = UIColor.appWhite186()
        } else {
            self.dateReminderDescriptionCell.textView.text = model.dateReminderDescription
            self.dateReminderDescriptionCell.textView.textColor = UIColor.appBlack()
        }
        
        self.updateChangeStateButton()

        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
        self.model = model
    }
    
    private func updateChangeStateButton() {
        self.changeStateButton .setImage(UIImage(named: self.task.state == Task.State.Active ? "task-undone" : "task-done"), forState: UIControlState.Normal)
    }
    
    @IBAction func closePressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func changeStatePressed(sender: AnyObject) {
        self.task.changeState()
        self.updateChangeStateButton()
    }
    
    /// Mark: UITableViewDataSource
    private var sections: [[UITableViewCell]] {
        var sections = [[UITableViewCell]]()
        
        /// section 1
        sections.append([self.createSeparatorCell(), self.titleCell])
        
        /// section 2
        sections.append([self.createSeparatorCell(), self.longDescriptionCell])
        
        /// section 3
        if self.task.locationReminder != nil {
            sections.append([self.createSeparatorCell(), self.locationCell, self.locationReminderDescriptionCell])
        } else {
            sections.append([self.createSeparatorCell(), self.locationReminderDescriptionCell])
        }
        
        /// section 4
        sections.append([self.createSeparatorCell(), self.dateReminderDescriptionCell])
        
        return sections
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.sections[indexPath.section][indexPath.row]
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = self.sections[indexPath.section][indexPath.row]
        if (cell is TextViewCell) {
            return (cell as TextViewCell).textView.proposedHeight
        } else if (cell is MapCell) {
            return 150.0
        } else if (cell is SeparatorCell) {
            return 20.0
        }
        
        return 50.0
    }
}

protocol DetailViewControllerDelegate {
    func viewControllerDidSelectHashtag(viewController: DetailViewController, hashtag: String)
}
