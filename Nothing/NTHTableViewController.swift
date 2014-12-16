//
//  NTHTableViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 21/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    enum CellIdentifier: String {
        case TextViewCell = "TextViewCell"
        case MapCell = "MapCell"
        case SeparatorCell = "SeparatorCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
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
        self.tableView.layoutMargins = UIEdgeInsetsZero
        self.tableView.separatorInset = UIEdgeInsetsZero
    }
    
    /// Mark Factory methods
    func createTitleCell() -> TextViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(CellIdentifier.TextViewCell.rawValue) as TextViewCell
        cell.textView.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        cell.textView.textContainerInset = UIEdgeInsets(top: 20, left: 5, bottom: 20, right: 5)
        return cell
    }
    
    func createLongDescriptionCell() -> TextViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(CellIdentifier.TextViewCell.rawValue) as TextViewCell
        cell.textView.font = UIFont(name: "HelveticaNeue-Thin", size: 17.0)
        cell.textView.textContainerInset = UIEdgeInsets(top: 20, left: 5, bottom: 20, right: 5)
        return cell
    }
    
    func createLocationReminderDescriptionCell() -> TextViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(CellIdentifier.TextViewCell.rawValue) as TextViewCell
        cell.textView.font = UIFont(name: "HelveticaNeue-Thin", size: 17.0)
        cell.textView.textContainerInset = UIEdgeInsets(top: 20, left: 5, bottom: 20, right: 5)
        return cell
    }
    
    func createDateReminderDescriptionCell() -> TextViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(CellIdentifier.TextViewCell.rawValue) as TextViewCell
        cell.textView.font = UIFont(name: "HelveticaNeue-Thin", size: 17.0)
        cell.textView.textContainerInset = UIEdgeInsets(top: 20, left: 5, bottom: 20, right: 5)
        return cell
    }
    
    func createSeparatorCell() -> SeparatorCell {
        return self.tableView.dequeueReusableCellWithIdentifier(CellIdentifier.SeparatorCell.rawValue) as SeparatorCell
    }
    
    /// Mark: UITableViewDelegate & UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
