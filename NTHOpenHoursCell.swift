//
//  NTHOpenHoursCell.swift
//  Nothing
//
//  Created by Tomasz Szulc on 25/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

protocol NTHOpenHoursCellDelegate {
    func cellDidTapClock(cell: NTHOpenHoursCell)
    func cellDidTapClose(cell: NTHOpenHoursCell, closed: Bool)
}

class NTHOpenHoursCell: UITableViewCell {
    @IBOutlet weak var dayNameLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
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
    }
    
    @IBAction func clockPressed(sender: AnyObject) {
        if self.closeButton.tag == 1 {
            return
        }
        
        self.delegate?.cellDidTapClock(self)
    }
    
    @IBAction func closePressed(sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
        } else {
            sender.tag = 0
        }
        
        self.markClosed(sender.tag == 1)
        self.delegate?.cellDidTapClose(self, closed: sender.tag == 1)
    }
    
    
    func update(closed: Bool) {
        self.closeButton.tag = Int(closed)
        self.markClosed(closed)
    }
    
    func markClosed(closed: Bool) {
        self._updateHourLabel()
        self._updateClosedLabel()
        self._updateCloseButton()
        self._updateClockButton()
    }
    
    private func _updateClosedLabel() {
        self.closedLabel.hidden = self.closeButton.tag == 0
    }
    
    private func _updateHourLabel() {
        self.hourLabel.hidden = self.closeButton.tag == 1
    }
    
    private func _updateCloseButton() {
        self._setViewEnabled(self.closeButton, enabled: self.closeButton.tag == 1)
    }
    
    private func _updateClockButton() {
        self._setViewEnabled(self.clockButton, enabled: self.closeButton.tag == 0)
    }
    
    private func _setViewEnabled(view: UIView, enabled: Bool) {
        view.alpha = enabled ? 1 : 0.3
    }
}
