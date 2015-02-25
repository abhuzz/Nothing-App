//
//  NTHOpenHoursCell.swift
//  Nothing
//
//  Created by Tomasz Szulc on 25/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

protocol NTHOpenHoursCellDelegate {
    func cellDidChangeSwitchValue(cell: NTHOpenHoursCell, value: Bool)
}

class NTHOpenHoursCell: UITableViewCell {
    @IBOutlet weak var dayNameLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var enabledSwitch: UISwitch!
    
    var delegate: NTHOpenHoursCellDelegate?

    @IBAction func switchChanged(sender: UISwitch) {
        self.delegate?.cellDidChangeSwitchValue(self, value: sender.on)
        self.markEnabled(sender.on)
    }
    
    func markEnabled(enabled: Bool) {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.dayNameLabel.alpha = enabled ? 1 : 0.3
            self.hourLabel.alpha = enabled ? 1 : 0.3
        })
    }
}
