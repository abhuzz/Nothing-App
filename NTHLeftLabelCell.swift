//
//  NTHLeftLabelCell.swift
//  Nothing
//
//  Created by Tomasz Szulc on 15/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHLeftLabelCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessoryType = .None
    }
    
    override var layoutMargins: UIEdgeInsets {
        set { super.layoutMargins = newValue }
        get { return UIEdgeInsetsZero }
    }
}
