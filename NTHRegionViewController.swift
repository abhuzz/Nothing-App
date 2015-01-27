//
//  NTHRegionViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 27/01/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHRegionViewController: UIViewController {
    
    typealias NTHRegionViewControllerBlock = (distance: Float, onArrive: Bool) -> Void
    var successBlock: NTHRegionViewControllerBlock?
    
    class Info {
        var distance: Float = 0.0
        var onArrive: Bool = true
    }
    
    private var info = Info()
    
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var curLabel: UILabel!
    @IBOutlet weak var slider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.minLabel.text = slider.value.distanceDescription()
        self.maxLabel.text = slider.value.distanceDescription()
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        self.curLabel.text = sender.value.distanceDescription()
        self.info.distance = sender.value
    }
    
    @IBAction func sliderEnded(sender: UISlider) {
        self.processValue(sender.value)
    }
    
    @IBAction func arriveOrLeavePressed(sender: UISegmentedControl) {
        self.info.onArrive = (sender.selectedSegmentIndex == 0)
    }
    
    private func processValue(value: Float) {
        var maxValue = min(value + 1000, 44_000_00)
        let minValue = max(value - 1000, 100)
        
        self.slider.minimumValue = minValue
        self.slider.maximumValue = maxValue
        
        self.minLabel.text = minValue.distanceDescription()
        self.maxLabel.text = maxValue.distanceDescription()
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        self.successBlock?(distance: self.info.distance, onArrive: self.info.onArrive)
        self.navigationController?.popViewControllerAnimated(true)
    }
}


extension Float {
    func distanceDescription() -> String {
        if (self < 1000) {
            return NSString(format: "%.0f m", self)
        } else {
            return NSString(format: "%.1f km", self / 1000.0)
        }
    }
}