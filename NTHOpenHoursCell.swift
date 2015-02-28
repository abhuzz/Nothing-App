//
//  NTHOpenHoursCell.swift
//  Nothing
//
//  Created by Tomasz Szulc on 25/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

protocol NTHOpenHoursCellDelegate {
    func cellDidEnable(cell: NTHOpenHoursCell, enabled: Bool)
    func cellDidTapClock(cell: NTHOpenHoursCell)
    func cellDidTapClose(cell: NTHOpenHoursCell, closed: Bool)
}

class NTHOpenHoursCell: UITableViewCell {
    @IBOutlet weak var dayNameLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var useButton: UIButton!
    @IBOutlet weak var clockButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var closedLabel: UILabel!
    
    var delegate: NTHOpenHoursCellDelegate?

    
    override var layoutMargins: UIEdgeInsets {
        set { super.layoutMargins = newValue }
        get { return UIEdgeInsetsZero }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.closedLabel.hidden = true
        self.hourLabel.hidden = false
        self.closeButton.alpha = 0.3
        self.clockButton.alpha = 0.3
        self.useButton.alpha = 0.3
    }
    
    @IBAction func useButtonPressed(sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
        } else {
            sender.tag = 0
        }
        
        self.markEnabled(sender.tag == 1)
        self.delegate?.cellDidEnable(self, enabled: sender.tag == 1)
    }
    
    @IBAction func clockPressed(sender: AnyObject) {
        if self.useButton.tag != 1 {
            return
        }
        
        self.delegate?.cellDidTapClock(self)
    }
    
    @IBAction func closePressed(sender: UIButton) {
        if self.useButton.tag != 1 {
            return
        }
        
        if sender.tag == 0 {
            sender.tag = 1
            self.hourLabel.hidden = true
            self.closedLabel.hidden = false
            self.closeButton.alpha = 1
        } else {
            sender.tag = 0
            self.hourLabel.hidden = false
            self.closedLabel.hidden = true
            self.closeButton.alpha = 0.3
        }
        
        self.delegate?.cellDidTapClose(self, closed: self.tag == 1)
    }
    
    func markEnabled(enabled: Bool) {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            let alpha: CGFloat = enabled ? 1 : 0.3
            self.dayNameLabel.alpha = alpha
            self.hourLabel.alpha = alpha
            self.useButton.alpha = alpha
            self.clockButton.alpha = alpha
            
            if self.closeButton.tag == 1 {
                self.closeButton.alpha = alpha
                self.closedLabel.alpha = alpha
            }
        })
    }
}
