//
//  NTHTaskDetailViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 15/12/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHTaskDetailViewController: UIViewController {
    
    /// views
    @IBOutlet private weak var mapCell: NTHMapCellView!
    @IBOutlet private weak var titleCell: NTHCellView!
    @IBOutlet private weak var descriptionCell: NTHCellView!
    @IBOutlet private weak var statusCell: NTHStateCellView!
    @IBOutlet private weak var remindMeAtLocationCell: NTHCellView!
    @IBOutlet private weak var distanceCell: NTHCellView!
    @IBOutlet private weak var remindMeOnDateCell: NTHCellView!
    @IBOutlet private weak var repeatCell: NTHCellView!
    
    /// public
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCells()
        
        self.updateWithModel(NTHTaskDisplayable(task: self.task))
    }
    
    private func setupCells() {
        self.titleCell.setTitle(NSLocalizedString("Title", comment: ""))
        self.descriptionCell.setTitle(NSLocalizedString("Description", comment: ""))
        self.statusCell.setTitle(NSLocalizedString("Status", comment: ""))
        self.remindMeAtLocationCell.setTitle(NSLocalizedString("Remind me at location", comment: ""))
        self.distanceCell.setTitle(NSLocalizedString("Distance", comment: ""))
        self.remindMeOnDateCell.setTitle(NSLocalizedString("Remind me on date", comment: ""))
        self.repeatCell.setTitle(NSLocalizedString("Repeat", comment: ""))
    }
    
    private func updateWithModel(displayable: NTHTaskDisplayable) {
        let noneString = NSLocalizedString("None", comment: "")
        let notSelectedString = NSLocalizedString("Not selected", comment: "")

        self.title = displayable.taskTitle
        
        /// title
        self.titleCell.setDetail(displayable.taskTitle)
        
        /// description
        self.descriptionCell.setDetail(displayable.taskDescription ?? noneString)
        self.descriptionCell.setEnabled(displayable.taskDescription != nil ? true : false)
        
        /// detail
        self.statusCell.setDetail(displayable.taskStateDescription)
        self.statusCell.statusView.state = displayable.task.state
        
        /// location
        self.remindMeAtLocationCell.setDetail(displayable.nameOfLocationInReminder ?? notSelectedString)
        self.remindMeAtLocationCell.setEnabled(displayable.nameOfLocationInReminder != nil)
        
        /// distance
        self.distanceCell.setDetail(displayable.distanceString ?? notSelectedString)
        self.distanceCell.setEnabled(displayable.distanceString != nil ? true : false)
        
        /// date
        self.remindMeOnDateCell.setDetail(displayable.dateStringInReminder ?? notSelectedString)
        self.remindMeOnDateCell.setEnabled(displayable.dateStringInReminder != nil ? true : false)

        /// repeat interval
        self.repeatCell.setDetail(displayable.repeatString ?? notSelectedString)
        self.repeatCell.setEnabled(displayable.repeatString != nil ? true : false)
        
        /// map
        if let reminder = displayable.task.locationReminder {
            self.mapCell.mapHidden(false)
            self.mapCell.displayAnnotationPointWithCoordinate(reminder.place.coordinate)
        } else {
            self.mapCell.mapHidden(true)
        }
    }
}
