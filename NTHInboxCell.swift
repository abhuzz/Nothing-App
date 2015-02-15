//
//  NTHInboxCell.swift
//  Nothing
//
//  Created by Tomasz Szulc on 07/12/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

protocol NTHInboxCellDelegate: class {
    func cellDidTapActionButton(cell: NTHInboxCell)
}

class NTHInboxCell: UITableViewCell {
    /// outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var stateIndicatorView: NTHTaskStatusView!
    @IBOutlet private weak var actionsButton: UIButton!
    @IBOutlet private weak var titleBottomToCenterYConstraint: NSLayoutConstraint!
    
    weak var delegate: NTHInboxCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.setupUI()
    }
    
    private func setupUI() {
        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0)
        
        self.titleLabel.font = UIFont.NTHInboxCellTitleFont()
        self.titleLabel.textColor = UIColor.NTHHeaderTextColor()
        
        self.descriptionLabel.font = UIFont.NTHInboxCellDescriptionFont()
        self.descriptionLabel.textColor = UIColor.NTHSubtitleTextColor()
        
        self.stateIndicatorView.state = .Active
    }
    
    func update(model: NTHInboxCellViewModel) {
        self.titleLabel.text = model.title
        self.descriptionLabel.text = model.longDescription
        
        if model.longDescription == ""  {
            self.titleBottomToCenterYConstraint.constant = CGRectGetHeight(self.stateIndicatorView.bounds) - 1
            self.titleLabel.updateConstraintsIfNeeded()
        } else {
            self.titleBottomToCenterYConstraint.constant = 0
        }
        
        stateIndicatorView.state = model.state
    }
    
    @IBAction func actionButtonPressed(sender: AnyObject) {
        self.delegate?.cellDidTapActionButton(self)
    }
}
