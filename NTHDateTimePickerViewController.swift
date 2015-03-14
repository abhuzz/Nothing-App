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
    
    
    class func instantiate() -> NTHDateTimePickerViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NTHDateTimePickerViewController") as! NTHDateTimePickerViewController
    }
    
    
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
        var componenets: NSDateComponents = NSCalendar.autoupdatingCurrentCalendar().components(NSCalendarUnit.YearCalendarUnit|NSCalendarUnit.MonthCalendarUnit|NSCalendarUnit.DayCalendarUnit|NSCalendarUnit.HourCalendarUnit|NSCalendarUnit.MinuteCalendarUnit, fromDate: self.datePicker.date)
        componenets.second = 0
        let date = NSCalendar.autoupdatingCurrentCalendar().dateFromComponents(componenets)!
        self.completionBlock?(selectedDate: date)
        super.donePressed(sender)
    }
}
