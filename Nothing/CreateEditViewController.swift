//
//  CreateEditViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 21/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

class CreateEditViewController: NTHTableViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var navigationBarHeight: NSLayoutConstraint!
    
    var taskTitle: String?
    
    private enum Segue: String {
        case TextEditor = "TextEditor"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBarHeight.constant = 64.0;
        self.tableView.contentInset = UIEdgeInsets(top: self.navigationBarHeight.constant, left: 0, bottom: 0, right: 0)
        
        /// use `taskTitle` if set already
        self.titleCell.textView.text = taskTitle
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func closePressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    lazy private var titleCell : TextViewCell = {
        let cell = self.createTitleCell()
        cell.selectionStyle = UITableViewCellSelectionStyle.Default
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.appBlueColorAlpha50()
        cell.selectedBackgroundView = selectedView
        
        return cell
    }()
    
    private var sections: [[UITableViewCell]] {
        var sections = [[UITableViewCell]]()
    
        /// section 1
        sections.append([self.createSeparatorCell(), self.titleCell])
        
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
            self.performSegueWithIdentifier(Segue.TextEditor.rawValue, sender: self.titleCell.textView.text)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == Segue.TextEditor.rawValue) {
            let vc = segue.destinationViewController as TextEditorViewController
            vc.text = sender as? String
            vc.confirmBlock = { value in [self, vc]
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    self.titleCell.setText(value)
                    self.tableView.reloadData()
                })
            }
        }
    }
}
