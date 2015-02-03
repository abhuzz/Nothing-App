//
//  NTHConnectionCell.swift
//  Nothing
//
//  Created by Tomasz Szulc on 31/01/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

protocol NTHConnectionCellDelegate {
    func cellDidTapClearButton(cell: NTHConnectionCell)
}

class NTHConnectionCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    
    var delegate: NTHConnectionCellDelegate?
    
    override var layoutMargins: UIEdgeInsets {
        set { super.layoutMargins = newValue }
        get { return UIEdgeInsetsZero }
    }
    
    @IBAction func onClearPressed(sender: AnyObject) {
        self.delegate?.cellDidTapClearButton(self)
    }
}
