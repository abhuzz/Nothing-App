//
//  NTHDatePickerViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 28/01/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHDatePickerViewController: UIViewController {
    
    typealias NTHDatePickerViewControllerBlock = (date: NSDate) -> Void
    var block: NTHDatePickerViewControllerBlock?

    @IBOutlet private weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePicker.setDate(NSDate(), animated: false)
        self.datePicker.minimumDate = self.datePicker.date
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        self.block?(date: self.datePicker.date)
        self.navigationController?.popViewControllerAnimated(true)
    }
}
