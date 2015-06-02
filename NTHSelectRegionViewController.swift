//
//  NTHSelectRegionViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 07/03/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

struct RegionAndDistance {
    var onArrive: Bool
    var distance: Float
}

class NTHSelectRegionViewController: UIViewController {
   
    @IBOutlet private weak var regionControl: NTHRegionControl!

    var reminder: LocationReminder!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.regionControl.configure(self.reminder.distance.floatValue, onArrive: self.reminder.onArrive.boolValue)
        self.regionControl.prepareBeforePresenting()
        self.regionControl.valueChangedBlock = { value in
            self.reminder.distance = value
        }
        
        self.regionControl.onArriveChangedBlock = { onArrive in
            self.reminder.onArrive = onArrive
        }
    }
}
