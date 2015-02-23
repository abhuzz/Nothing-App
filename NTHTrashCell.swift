//
//  NTHTrashCell.swift
//  Nothing
//
//  Created by Tomasz Szulc on 23/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

protocol NTHTrashCellDelegate {
    func cellDidPressRestore(cell: NTHInboxCell)
    func cellDidPressDelete(cell: NTHInboxCell)
}

class NTHTrashCell: NTHInboxCell {

    var delegate: NTHTrashCellDelegate?
    
    @IBAction private func restorePressed(sender: AnyObject) {
        self.delegate?.cellDidPressRestore(self)
    }
    
    @IBAction private func deletePressed(sender: AnyObject) {
        self.delegate?.cellDidPressDelete(self)
    }
}
