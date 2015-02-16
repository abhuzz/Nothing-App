//
//  NTHContactCell.swift
//  Nothing
//
//  Created by Tomasz Szulc on 01/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHLeftLabelRemoveCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    var clearPressedBlock: ((cell: UITableViewCell) -> Void)?
    
    @IBAction func clearPressed(sender: AnyObject) {
        self.clearPressedBlock?(cell: self)
    }
}
