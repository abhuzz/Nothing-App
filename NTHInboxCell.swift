//
//  NTHInboxCell.swift
//  Nothing
//
//  Created by Tomasz Szulc on 07/12/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHInboxCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var stateIndicatorView: UIView!
    @IBOutlet weak var actionsButton: UIButton!
    @IBOutlet weak var spaceToCenterConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.setup()
    }
    
    private func setup() {
        self.titleLabel.font = UIFont.NTHInboxCellTitleFont()
        self.titleLabel.textColor = UIColor.NTHCadetGrayColor()
        
        self.descriptionLabel.font = UIFont.NTHInboxCellDescriptionFont()
        self.descriptionLabel.textColor = UIColor.NTHLinkWaterColor()
    }
}
