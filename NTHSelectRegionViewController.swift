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

    var settings: RegionAndDistance!
    var completionBlock: ((settings: RegionAndDistance) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.regionControl.configure(self.settings.distance, onArrive: self.settings.onArrive)
        self.regionControl.prepareBeforePresenting()
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        self.settings.onArrive = (self.regionControl.regionSegmentedControl.selectedSegmentIndex == 0)
        self.settings.distance = self.regionControl.regionSlider.value
        self.completionBlock?(settings: self.settings)
        self.navigationController?.popViewControllerAnimated(true)
    }
}
