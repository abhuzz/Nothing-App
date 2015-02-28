//
//  NTHDateTimePickerViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 24/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHDateTimePickerViewController: NTHSheetViewController {

    
    @IBOutlet private weak var datePicker: UIDatePicker!
    
    
    var completionBlock: ((selectedDate: NSDate) -> Void)?
    
    var editedDate: NSDate?
    var mode: UIDatePickerMode?
    
    func setDate(date: NSDate) {
        self.editedDate = date
    }
    
    func setPickerMode(mode: UIDatePickerMode) {
        self.mode = mode
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let date = self.editedDate {
            self.datePicker.date = date
        }
        
        if let mode = self.mode {
            self.datePicker.datePickerMode = mode
        }
    }
    
    @IBAction override func donePressed(sender: AnyObject) {
        self.completionBlock?(selectedDate: self.datePicker.date)
        super.donePressed(sender)
    }
}
