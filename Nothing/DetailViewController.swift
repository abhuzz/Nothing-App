//
//  DetailViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 16/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var task: Task!
    var delegate: DetailViewControllerDelegate?
    private var model: DetailModelView?
    
    @IBOutlet weak var tableView: UITableView!
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
        let cell = self.tableView.dequeueReusableCellWithIdentifier(CellIdentifier.TextViewCell.rawValue) as TextViewCell
        cell.textView.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        cell.textView.textContainerInset = UIEdgeInsets(top: 20, left: 5, bottom: 20, right: 5)
        return cell
    }()
    
    lazy private var longDescriptionCell: TextViewCell = {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(CellIdentifier.TextViewCell.rawValue) as TextViewCell
        cell.textView.font = UIFont(name: "HelveticaNeue-Thin", size: 17.0)
        cell.textView.textContainerInset = UIEdgeInsets(top: 20, left: 5, bottom: 20, right: 5)
        return cell
    }()
    
    lazy private var locationReminderDescriptionCell: TextViewCell = {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(CellIdentifier.TextViewCell.rawValue) as TextViewCell
        cell.textView.font = UIFont(name: "HelveticaNeue-Thin", size: 17.0)
        cell.textView.textContainerInset = UIEdgeInsets(top: 20, left: 5, bottom: 20, right: 5)
        return cell
    }()
    
    lazy private var locationCell: MapCell = {
        return self.tableView.dequeueReusableCellWithIdentifier(CellIdentifier.MapCell.rawValue) as MapCell
    }()
    
    lazy private var dateReminderDescriptionCell: TextViewCell = {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(CellIdentifier.TextViewCell.rawValue) as TextViewCell
        cell.textView.font = UIFont(name: "HelveticaNeue-Thin", size: 17.0)
        cell.textView.textContainerInset = UIEdgeInsets(top: 20, left: 5, bottom: 20, right: 5)
        return cell
    }()
    
    private func createSeparatorCell() -> SeparatorCell {
        return (self.tableView.dequeueReusableCellWithIdentifier(CellIdentifier.SeparatorCell.rawValue) as SeparatorCell)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBarHeight.constant = 64.0;
        self.configureTableView()
        self.update()
    }
    
    private func configureTableView() {
        self.tableView.backgroundColor = UIColor.appWhite250()

        let textViewCellNib = UINib(nibName: CellIdentifier.TextViewCell.rawValue, bundle: nil)
        self.tableView.registerNib(textViewCellNib, forCellReuseIdentifier: CellIdentifier.TextViewCell.rawValue)
        
        let mapCellNib = UINib(nibName: CellIdentifier.MapCell.rawValue, bundle: nil)
        self.tableView.registerNib(mapCellNib, forCellReuseIdentifier: CellIdentifier.MapCell.rawValue)
        
        let separatorCellNib = UINib(nibName: CellIdentifier.SeparatorCell.rawValue, bundle: nil)
        self.tableView.registerNib(separatorCellNib, forCellReuseIdentifier: CellIdentifier.SeparatorCell.rawValue)
        
        self.tableView.tableFooterView = UIView()
        self.tableView.contentInset = UIEdgeInsets(top: self.navigationBarHeight.constant, left: 0, bottom: 0, right: 0)
        self.tableView.layoutMargins = UIEdgeInsetsZero
        self.tableView.separatorInset = UIEdgeInsetsZero
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
        self.changeStateButton .setImage(UIImage(named: self.task.state == Task.State.Active ? "mark-undone" : "mark-done"), forState: UIControlState.Normal)
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
