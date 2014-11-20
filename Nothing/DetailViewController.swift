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

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var navigationBarHeight: NSLayoutConstraint!
    @IBOutlet weak var changeStateButton: UIButton!
    
    /// cells
    private var _titleCell: TextViewCell?
    private var titleCell: TextViewCell {
        if _titleCell == nil {
            _titleCell = self.tableView.dequeueReusableCellWithIdentifier("TextViewCell") as? TextViewCell
            _titleCell!.textView.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
            _titleCell!.textView.textContainerInset = UIEdgeInsets(top: 20, left: 5, bottom: 20, right: 5)
        }
        
        return _titleCell!
    }
    
    private var _longDescriptionCell: TextViewCell?
    private var longDescriptionCell: TextViewCell {
        if _longDescriptionCell == nil {
            _longDescriptionCell = self.tableView.dequeueReusableCellWithIdentifier("TextViewCell") as? TextViewCell
            _longDescriptionCell!.textView.font = UIFont(name: "HelveticaNeue-Thin", size: 17.0)
            _longDescriptionCell!.textView.textContainerInset = UIEdgeInsets(top: 20, left: 5, bottom: 20, right: 5)
        }
        
        return _longDescriptionCell!
    }
    
    private var _locationReminderDescriptionCell: TextViewCell?
    private var locationReminderDescriptionCell: TextViewCell {
        if _locationReminderDescriptionCell == nil {
            _locationReminderDescriptionCell = self.tableView.dequeueReusableCellWithIdentifier("TextViewCell") as? TextViewCell
            _locationReminderDescriptionCell!.textView.font = UIFont(name: "HelveticaNeue-Thin", size: 17.0)
            _locationReminderDescriptionCell!.textView.textContainerInset = UIEdgeInsets(top: 20, left: 5, bottom: 20, right: 5)
        }
        
        return _locationReminderDescriptionCell!
    }
    
    private var _locationCell: MapCell?
    private var locationCell: MapCell {
        if _locationCell == nil {
            _locationCell = self.tableView.dequeueReusableCellWithIdentifier("MapCell") as? MapCell
        }
        
        return _locationCell!
    }
    
    private var _dateReminderDescriptionCell: TextViewCell?
    private var dateReminderDescriptionCell: TextViewCell {
        if _dateReminderDescriptionCell == nil {
            _dateReminderDescriptionCell = self.tableView.dequeueReusableCellWithIdentifier("TextViewCell") as? TextViewCell
            _dateReminderDescriptionCell!.textView.font = UIFont(name: "HelveticaNeue-Thin", size: 17.0)
            _dateReminderDescriptionCell!.textView.textContainerInset = UIEdgeInsets(top: 20, left: 5, bottom: 20, right: 5)
        }
        
        return _dateReminderDescriptionCell!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.appWhite250()
        self.navigationBarHeight.constant = 64.0;

        let textViewCellNib = UINib(nibName: "TextViewCell", bundle: nil)
        self.tableView.registerNib(textViewCellNib, forCellReuseIdentifier: "TextViewCell")
        
        let mapCellNib = UINib(nibName: "MapCell", bundle: nil)
        self.tableView.registerNib(mapCellNib, forCellReuseIdentifier: "MapCell")
        
        self.tableView.tableFooterView = UIView()
        self.tableView.contentInset = UIEdgeInsets(top: self.navigationBarHeight.constant, left: 0, bottom: 0, right: 0)
        self.tableView.layoutMargins = UIEdgeInsetsZero
        self.tableView.separatorInset = UIEdgeInsetsZero
        
        self.update()
    }
    
    func update() {
        let model = DetailModelView(self.task)
        self.titleCell.textView.text = model.title
        self.longDescriptionCell.textView.text = model.longDescription
        self.longDescriptionCell.textView.textColor = model.isDescription ? UIColor.appBlack() : UIColor.appWhite186()
        
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
    private var cells: [UITableViewCell] {
        var cells = [UITableViewCell]()
        cells.append(self.titleCell)
        cells.append(self.longDescriptionCell)
        if self.task.locationReminder != nil {
            cells.append(self.locationCell)
            cells.append(self.locationReminderDescriptionCell)
        } else {
            cells.append(self.locationReminderDescriptionCell)
        }
        
        cells.append(self.dateReminderDescriptionCell)
        
        return cells
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.cells.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.cells[indexPath.section]
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = self.cells[indexPath.section]
        if (cell is TextViewCell) {
            return (cell as TextViewCell).textView.proposedHeight
        } else if (cell is MapCell) {
            return 150.0
        }
        
        return 50.0
    }
}
