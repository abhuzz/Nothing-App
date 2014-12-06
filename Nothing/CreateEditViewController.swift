//
//  CreateEditViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 21/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

class CreateEditViewController: NTHTableViewController {
    
    var taskTitle: String?
    
    private enum Segue: String {
        case TextEditor = "TextEditor"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
        
        /// use `taskTitle` if set already
        self.titleCell.textView.text = taskTitle
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.topItem?.setLeftBarButtonItem(UIBarButtonItem.backButton(self, action: "closePressed"), animated: false)
        self.navigationController?.navigationBar.topItem?.setRightBarButtonItem(UIBarButtonItem.saveButton(self, action: "onConfirmPressed"), animated: false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "New Task"
    }
    
    func closePressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onConfirmPressed() {
        
    }
    
    lazy private var titleCell: TextViewCell = {
        let cell = self.createTitleCell()
        CreateEditViewController.addSelectionViewToCell(cell)
        return cell
    }()
    
    lazy private var longDescriptionCell: TextViewCell = {
        let cell = self.createLongDescriptionCell()
        CreateEditViewController.addSelectionViewToCell(cell)
        return cell
    }()
    
    class private func addSelectionViewToCell(cell: UITableViewCell) {
        cell.selectionStyle = UITableViewCellSelectionStyle.Default

        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.appBlueColorAlpha50()
        cell.selectedBackgroundView = selectedView
    }
    
    private var sections: [[UITableViewCell]] {
        var sections = [[UITableViewCell]]()
    
        /// section 1
        sections.append([self.createSeparatorCell(), self.titleCell])
        
        /// section 2
        sections.append([self.createSeparatorCell(), self.longDescriptionCell])
        
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if (cell == self.titleCell) {
            self.performSegueWithIdentifier(Segue.TextEditor.rawValue, sender: self.titleCell)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == Segue.TextEditor.rawValue) {
            let navVC = segue.destinationViewController as UINavigationController
            let vc = navVC.topViewController as TextEditorViewController
            if (sender is TextViewCell) {
                let cell = sender as TextViewCell
                if (cell == self.titleCell) {
                    vc.title = "Title"
                    vc.text = self.titleCell.textView.text
                    vc.confirmBlock = { value in [self, vc]
                        self.titleCell.setText(value)
                        self.tableView.reloadData()
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
            }
            
        }
    }
}
