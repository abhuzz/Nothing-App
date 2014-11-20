//
//  SeparatorCell.swift
//  Nothing
//
//  Created by Tomasz Szulc on 20/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

class SeparatorCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()
        self.layoutMargins = UIEdgeInsetsZero
    }
}
