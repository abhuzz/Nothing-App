//
//  NTHOpenHoursPickerViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 27/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHOpenHoursPickerViewController: NTHSheetViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    
    var completionBlock: ((openHourTimeInterval: NSTimeInterval, closeHourTimeInterval: NSTimeInterval) -> Void)?
    
    var openHourTimeInterval: NSTimeInterval! = 0
    var closeHourTimeInterval: NSTimeInterval! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.selectRow(Int(((self.openHourTimeInterval / 60.0) / 5.0)), inComponent: 0, animated: false)
        self.pickerView.selectRow(Int(((self.closeHourTimeInterval / 60.0) / 5.0)), inComponent: 1, animated: false)
    }
    
    @IBAction override func donePressed(sender: AnyObject) {
        let openValue = self.pickerView.selectedRowInComponent(0)
        let closeValue = self.pickerView.selectedRowInComponent(1)
        
        self.completionBlock?(openHourTimeInterval: NSTimeInterval(openValue * 60 * 5), closeHourTimeInterval: NSTimeInterval(closeValue * 60 * 5))
        super.donePressed(sender)
    }
    
    /// Mark: UIPickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 24 /*h*/ * 12 /* 12 pieces, 5 minutes each */
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self._timeForRow(row).toString()
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    private func _timeForRow(row: Int) -> NTHTime {
        let timeInSeconds: NSTimeInterval = NSTimeInterval(row * 5 /* minutes */ * 60 /* secs */)
        return NTHTime(interval: timeInSeconds)
    }
}
