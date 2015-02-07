//
//  NTHCenterLabelCell.swift
//  Nothing
//
//  Created by Tomasz Szulc on 07/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHCenterLabelCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    override var layoutMargins: UIEdgeInsets {
        set { super.layoutMargins = newValue }
        get { return UIEdgeInsetsZero }
    }
}
