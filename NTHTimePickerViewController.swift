//
//  NTHTimePickerViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 24/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHTimePickerViewController: NTHSheetViewController {

    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        
    }
    
    @IBAction func handleBackgroundTap(sender: AnyObject) {
        NTHUnwindSheetSegue(identifier: "CloseSheet", source: self, destination: self.presentingViewController as UIViewController!).perform()
    }
}
