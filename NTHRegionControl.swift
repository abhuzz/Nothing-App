//
//  NTHRegionControl.swift
//  Nothing
//
//  Created by Tomasz Szulc on 16/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHRegionControl: UIView {
    
    @IBOutlet weak var regionSlider: UISlider!
    @IBOutlet weak var minRegionLabel: UILabel!
    @IBOutlet weak var curRegionLabel: UILabel!
    @IBOutlet weak var maxRegionLabel: UILabel!
    @IBOutlet weak var regionSegmentedControl: UISegmentedControl!

    
    private class Info {
        var distance: Float = 0.0
        var onArrive: Bool = true
    }
    
    private var info = Info()
    
    
    
    var valueChangedBlock: ((value: Float) -> Void)?
    var onArriveChangedBlock: ((onArrive: Bool) -> Void)?
    
    
    override func awakeAfterUsingCoder(aDecoder: NSCoder) -> AnyObject? {
        return self.NTHAwakeAfterUsingCoder(aDecoder, nibName: "NTHRegionControl")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.regionSlider.minimumTrackTintColor = UIColor.NTHNavigationBarColor()
        self.minRegionLabel.textColor = UIColor.NTHHeaderTextColor()
        self.curRegionLabel.textColor = UIColor.NTHHeaderTextColor()
        self.maxRegionLabel.textColor = UIColor.NTHHeaderTextColor()
        self.regionSegmentedControl.tintColor = UIColor.NTHNavigationBarColor()
    }
    
    func configure(distance: Float, onArrive: Bool) {
        self.info.distance = distance
        self.info.onArrive = onArrive
    }
    
    func prepareBeforePresenting() {
        self.minRegionLabel.text = self.regionSlider.value.metersOrKilometers()
        self.maxRegionLabel.text = self.regionSlider.value.metersOrKilometers()
        
        self.processValue(self.info.distance)
        self.regionSegmentedControl.selectedSegmentIndex = Int(self.info.onArrive ? 0 : 1)
    }
    
    @IBAction private func sliderValueChanged(sender: UISlider) {
        self.curRegionLabel.text = sender.value.metersOrKilometers()
        self.info.distance = sender.value
        self.valueChangedBlock?(value: sender.value)
    }
    
    @IBAction private func sliderEnded(sender: UISlider) {
        self.processValue(sender.value)
    }
    
    @IBAction private func arriveOrLeavePressed(sender: UISegmentedControl) {
        self.info.onArrive = (sender.selectedSegmentIndex == 0)
        self.onArriveChangedBlock?(onArrive: self.info.onArrive)
    }
    
    private func processValue(value: Float) {
        var maxValue = min(value + 1000, 44_000_00)
        let minValue = max(value - 1000, 100)
        
        self.regionSlider.minimumValue = minValue
        self.regionSlider.maximumValue = maxValue
        self.regionSlider.value = value
        
        self.minRegionLabel.text = minValue.metersOrKilometers()
        self.maxRegionLabel.text = maxValue.metersOrKilometers()
        self.curRegionLabel.text = value.metersOrKilometers()
    }
    
}
