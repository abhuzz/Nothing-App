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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    struct Time {
        let hours: Int
        let minutes: Int
        
        var stringRepresentation: String {
            return String(format: "%02d:%02d", self.hours, self.minutes)
        }
    }
    
    
    /// Mark: UIPickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 24 * 12
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self._timeForRow(row).stringRepresentation
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    private func _timeForRow(row: Int) -> Time {
        let timeInMinutes = row * 5 /* minutes */
        let hours = timeInMinutes / 60
        let minutes = timeInMinutes - (hours * 60)
        return Time(hours: hours, minutes: minutes)
    }
}
