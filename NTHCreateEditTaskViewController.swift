//
//  NTHCreateEditTaskViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 15/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class LocationReminderContainer {
    
}

class DateReminderContainer {
    
}

class TaskContainer {
    var title: String?
    var locationReminders = [LocationReminderContainer]()
    var dateReminders = [DateReminderContainer]()
    var links = [Connection]()
}

class NTHCreateEditTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private weak var titleTextField: NTHTextField!
    
    @IBOutlet private weak var locationsTableView: UITableView!
    @IBOutlet weak var locationsTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var datesTableView: UITableView!
    @IBOutlet private weak var datesTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var linksTableView: UITableView!
    @IBOutlet weak var linksTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var notesTextView: NTHPlaceholderTextView!
    
    

    private var taskContainer = TaskContainer()

    enum TableViewType: Int {
        case Locations, Dates, Links
    }
    
    private enum SegueIdentifier: String {
        case CreateLocationReminder = "CreateLocationReminder"
        case EditLocationReminder = "EditLocationReminder"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._configureTitleTextField()
        
        let centerLabelCell = UINib(nibName: "NTHCenterLabelCell", bundle: nil)
        let centerLabelCellIdentifier = "NTHCenterLabelCell"
        self.locationsTableView.registerNib(centerLabelCell, forCellReuseIdentifier: centerLabelCellIdentifier)
        self.datesTableView.registerNib(centerLabelCell, forCellReuseIdentifier: centerLabelCellIdentifier)
        self.linksTableView.registerNib(centerLabelCell, forCellReuseIdentifier: centerLabelCellIdentifier)
        
        self._configureLocationsTableView()
        self._configureDatesTableView()
        self._configureLinksTableView()
    }
    
    private func _configureTitleTextField() {
        self.titleTextField.textFieldDidChangeBlock = { text in
            self.taskContainer.title = text
        }
    }
    
    private func _configureLocationsTableView() {
        self.locationsTableView.tag = TableViewType.Locations.rawValue
    }
    
    private func _configureDatesTableView() {
        self.datesTableView.tag = TableViewType.Dates.rawValue
    }
    
    private func _configureLinksTableView() {
        self.linksTableView.tag = TableViewType.Links.rawValue
    }

    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    

    /// Mark: UITableViewDelegate & UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView.type {
        case .Locations:
            return max(1, self.taskContainer.locationReminders.count)
            
        case .Dates:
            return max(1, self.taskContainer.dateReminders.count)
            
        case .Links:
            return max(1, self.taskContainer.links.count)
        }
    }
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        func _createAddNewSomethingCell(title: String) -> NTHCenterLabelCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHCenterLabelCell") as! NTHCenterLabelCell
            cell.label.font = UIFont(name: "AvenirNext-Regular", size: 14.0)
            cell.label.text = title
            cell.selectedBackgroundView = UIView()
            return cell
        }
        
        switch tableView.type {
        case .Locations:
            if self.taskContainer.locationReminders.count == 0 {
                return _createAddNewSomethingCell("+ Add new location")
            } else {
                return UITableViewCell()
            }
        case .Dates:
            if self.taskContainer.dateReminders.count == 0 {
                return _createAddNewSomethingCell("+ Add new date")
            } else {
                return UITableViewCell()
            }
        case .Links:
            if self.taskContainer.links.count == 0 {
                return _createAddNewSomethingCell("+ Add new link")
            } else {
                return UITableViewCell()
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.tableViewCellHeight()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch tableView.type {
        case .Locations:
            let addNewReminder = indexPath.row == self.taskContainer.locationReminders.count
            if addNewReminder {
                self.performSegueWithIdentifier(SegueIdentifier.CreateLocationReminder.rawValue, sender: nil)
            } else {
                var reminder = self.taskContainer.locationReminders[indexPath.row]
                self.performSegueWithIdentifier(SegueIdentifier.EditLocationReminder.rawValue, sender: reminder)
            }
            
        default:
            break
        }
    }
    
    private func _refreshTableView(tableView: UITableView, heightConstraint: NSLayoutConstraint, items: Int) {
        /// Update table view height
        let height = CGFloat(items) * self.tableViewCellHeight()
        heightConstraint.constant = height
        
        UIView.animateWithDuration(NSTimeInterval(0.3), animations: {
            self.view.needsUpdateConstraints()
            tableView.reloadData()
            return /// explicit return
        })
    }
    
    private func tableViewCellHeight() -> CGFloat {
        return 50.0
    }
}

extension UITableView {
    var type: NTHCreateEditTaskViewController.TableViewType {
        return NTHCreateEditTaskViewController.TableViewType(rawValue: self.tag)!
    }
}
