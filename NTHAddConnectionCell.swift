//
//  NTHAddConnectionCell.swift
//  Nothing
//
//  Created by Tomasz Szulc on 31/01/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHAddConnectionCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    override var layoutMargins: UIEdgeInsets {
        set { super.layoutMargins = newValue }
        get { return UIEdgeInsetsZero }
    }
}
