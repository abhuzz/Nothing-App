//
//  NTHEditTaskController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 25/01/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHEditTaskController: UIViewController, NTHConnectionsCellViewDelegate {

    @IBOutlet private weak var titleCell: NTHSimpleCellView!
    @IBOutlet private weak var descriptionCell: NTHSimpleCellView!
    @IBOutlet private weak var remindMeAtLocationCell: NTHSimpleCellView!
    @IBOutlet private weak var distanceCell: NTHSimpleCellView!
    @IBOutlet private weak var remindMeOnDateCell: NTHSimpleCellView!
    @IBOutlet private weak var repeatCell: NTHSimpleCellView!
    @IBOutlet private weak var connectionsCell: NTHConnectionsCellView!
    
    /// public
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCells()
        self.updateWithModel(NTHTaskDisplayable(task: self.task))
    }
    
    private func setupCells() {
        self.titleCell.setTitle(NSLocalizedString("Title", comment: ""))
        self.titleCell.showDisclosureIndicator(true)
        
        self.descriptionCell.setTitle(NSLocalizedString("Description", comment: ""))
        self.descriptionCell.showDisclosureIndicator(true)
        
        self.remindMeAtLocationCell.setTitle(NSLocalizedString("Remind me at location", comment: ""))
        self.remindMeAtLocationCell.showDisclosureIndicator(true)

        self.distanceCell.setTitle(NSLocalizedString("Distance", comment: ""))
        self.distanceCell.showDisclosureIndicator(true)

        self.remindMeOnDateCell.setTitle(NSLocalizedString("Remind me on date", comment: ""))
        self.remindMeOnDateCell.showDisclosureIndicator(true)

        self.repeatCell.setTitle(NSLocalizedString("Repeat", comment: ""))
        self.repeatCell.showDisclosureIndicator(true)

        self.connectionsCell.setTitle(NSLocalizedString("Connections", comment: ""))
        self.connectionsCell.showDisclosureIndicator(true)
        self.connectionsCell.delegate = self
    }
    
    private func updateWithModel(displayable: NTHTaskDisplayable) {
        let noneString = NSLocalizedString("None", comment: "")
        let notSelectedString = NSLocalizedString("Not selected", comment: "")
        
        self.title = displayable.taskTitle
        
        /// title
        self.titleCell.setDetail(displayable.taskTitle)
        
        /// description
        self.descriptionCell.setDetail(displayable.taskDescription ?? noneString)
        
        /// location
        self.remindMeAtLocationCell.setDetail(displayable.nameOfLocationInReminder ?? notSelectedString)
        
        /// distance
        self.distanceCell.setDetail(displayable.distanceString ?? notSelectedString)
        
        /// date
        self.remindMeOnDateCell.setDetail(displayable.dateStringInReminder ?? notSelectedString)
        
        /// repeat interval
        self.repeatCell.setDetail(displayable.repeatString ?? notSelectedString)
        
        self.connectionsCell.setConnections(self.task.allConnections.allObjects as [Connection])
    }
    
    
    /// Mark: NTHConnectionsCellViewDelegate
    func connectionsCell(cell: NTHConnectionsCellView, didSelectConnection connection: Connection) {
        /// get some name
        var name = ""
        if (connection is Contact) {
            name = (connection as Contact).name
        } else if (connection is Place) {
            name = (connection as Place).customName
        }
        
        /// create controller
        let controller = UIAlertController(title: name, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        /// add actions for connections
        let showDetails = UIAlertAction(title: "Show details", style: UIAlertActionStyle.Default) { (action) -> Void in
            
        }
        
        /// cancel
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            
        }
        
        controller.addAction(showDetails)
        controller.addAction(cancel)
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
}
